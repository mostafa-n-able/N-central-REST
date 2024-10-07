<#
.SYNOPSIS
A script that gets the list of devices and saves them in a csv file.

.DESCRIPTION
This script retrieves a list of devices from the N-central API and saves the data to a CSV file.
It uses the Get-Devices function to fetch the device data and exports it to a CSV file.

.INPUTS
None

.OUTPUTS
A CSV file containing the list of devices.

.NOTES
   .PROMPT
   A script that gets the list of devices and saves them in a csv file.
#>

# Define constants
$BaseURI = "https://api.example.com"  # Replace with your actual base URI
$JWTToken = "your_jwt_token_here"  # Replace with your actual JWT token

# Import required modules
Import-Module ./Authentication/Get-Access-Tokens.psm1
Import-Module ./Utilities.psm1
Import-Module ./Devices/Get-Devices.psm1

# Authenticate and get access token
try {
    $authTokens = Get-NcentralAuthTokens -Token $JWTToken -BaseUri $BaseURI
    $AccessToken = $authTokens.access_token
    Write-Debug "Successfully authenticated and received access token."
} catch {
    Write-Error "Failed to authenticate: $_"
    exit 1
}

# Initialize variables for pagination
$pageNumber = 1
$pageSize = 1000
$allDevices = @()

# Fetch devices with pagination
do {
    try {
        $response = Get-Devices -BaseURI $BaseURI -AccessToken $AccessToken -PageNumber $pageNumber -PageSize $pageSize | ConvertFrom-Json
        
        if ($response.data) {
            $allDevices += $response.data
            Write-Host "Retrieved $($response.data.Count) devices from page $pageNumber"
        }
        
        $pageNumber++
    } catch {
        Write-Error "Error fetching devices: $_"
        break
    }
} while ($response.data.Count -eq $pageSize)

# Check if any devices were retrieved
if ($allDevices.Count -eq 0) {
    Write-Warning "No devices were retrieved from the API."
    exit 0
}

# Prepare CSV file path
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvFilePath = ".\Devices_$timestamp.csv"

# Export devices to CSV
try {
    $allDevices | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Output "Successfully exported $($allDevices.Count) devices to $csvFilePath"
} catch {
    Write-Error "Failed to export devices to CSV: $_"
    exit 1
}
