<#
.SYNOPSIS
A script that gets activation keys for all devices on the server.

.DESCRIPTION
This script retrieves a list of devices from the N-central API and gets the activation key for each device.

.INPUTS
None

.OUTPUTS
A CSV file containing the list of devices and their activation key.

#>

# Define constants
$BaseURI = "https://api.example.com"  # Replace with your actual base URI
$JWTToken = "your_jwt_token_here"  # Replace with your actual JWT token

# Import required modules
Import-Module ./Authentication/Get-Access-Tokens.psm1
Import-Module ./Utilities.psm1
Import-Module ./Devices/Get-Devices.psm1
Import-Module ./Devices/Get-Activation-Key-By-Device-Id.psm1

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

# Fetch activation key for each device
Write-Host "Fetching activation keys for $($allDevices.Count) devices..."
$deviceCount = 0
foreach ($device in $allDevices) {
    $deviceCount++
    try {
        Write-Host "Processing device $deviceCount of $($allDevices.Count): Device ID $($device.deviceId)"
        $activationKeyResponse = Get-DeviceActivationKey -DeviceId $device.deviceId -BaseURI $BaseURI -AccessToken $AccessToken | ConvertFrom-Json
        
        # Add activation key as a new attribute to the device object
        $device | Add-Member -MemberType NoteProperty -Name "activationKey" -Value $activationKeyResponse.activationKey -Force
        
        Write-Debug "Successfully retrieved activation key for device $($device.deviceId)"
    } catch {
        Write-Warning "Failed to retrieve activation key for device $($device.deviceId): $_"
        # Add empty activation key if retrieval fails
        $device | Add-Member -MemberType NoteProperty -Name "activationKey" -Value "ERROR" -Force
    }
}

# Prepare CSV file path
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvFilePath = ".\Devices_$timestamp.csv"

# Export devices to CSV with only specified columns
try {
    $allDevices | Select-Object deviceId, longName, deviceClass, activationKey | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Output "Successfully exported $($allDevices.Count) devices to $csvFilePath"
} catch {
    Write-Error "Failed to export devices to CSV: $_"
    exit 1
}
