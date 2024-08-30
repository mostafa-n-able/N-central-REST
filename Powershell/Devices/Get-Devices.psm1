<#
    .SYNOPSIS
    Retrieves a list of devices from the N-central API.

    .DESCRIPTION
    This function sends a GET request to the /api/devices endpoint of the N-central API
    and returns the list of devices as a JSON object. It supports pagination and sorting.

    .INPUTS

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of devices.

    .NOTES

    .EXAMPLE
    $devices = Get-NCentralDevices -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -PageNumber 1 -PageSize 50 -SortBy "deviceId" -SortOrder "asc"
#>
function Get-NCentralDevices {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [int]$FilterId,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder = "ASC"
    )

    $ErrorActionPreference = 'Stop'
    #$DebugPreference = 'Continue'

    Write-Debug "Starting Get-NCentralDevices function"

    # Construct the API endpoint URL
    $apiEndpoint = "$BaseURI/api/devices"
    Write-Debug "API Endpoint: $apiEndpoint"

    # Construct query parameters
    $queryParams = @{}
    if ($FilterId) { $queryParams['filterId'] = $FilterId }
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    $queryString = New-HttpQueryString -Parameters $queryParams
    $fullUrl = "$apiEndpoint$queryString"
    Write-Debug "Full URL: $fullUrl"

    # Set up headers
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Accept' = 'application/json'
    }

    try {
        Write-Debug "Sending GET request to N-central API"
        $response = Invoke-RestMethod -Uri $fullUrl -Headers $headers -Method Get -ErrorAction Stop

        Write-Debug "Request successful. Processing response."
        return $response | ConvertTo-Json -Depth 10

    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "Error occurred while fetching devices: $statusCode $statusDescription"
        Write-Debug "Error details: $_"

        if ($statusCode -eq 401) {
            Write-Warning "Authentication failed. Please check your access token."
        }
        elseif ($statusCode -eq 403) {
            Write-Warning "Access forbidden. You may not have the necessary permissions."
        }
        elseif ($statusCode -eq 404) {
            Write-Warning "Resource not found. Please check the API endpoint URL."
        }
        elseif ($statusCode -ge 500) {
            Write-Warning "Server error occurred. Please try again later or contact support."
        }

        return $null
    }
}
