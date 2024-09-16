<#
    .SYNOPSIS
    Retrieves maintenance windows for a specific device.

    .DESCRIPTION
    This function retrieves all maintenance windows associated with a given device ID using the N-able N-central API.

    .PARAMETER DeviceId
    The ID of the device for which to retrieve maintenance windows.

    .PARAMETER BaseURI
    The base URI for the N-able N-central API.

    .PARAMETER AccessToken
    The access token required for authentication.

    .OUTPUTS
    Returns a JSON object containing the maintenance windows for the specified device.

    .NOTES
    This function is based on the N-able N-central API documentation.

    .EXAMPLE
    $maintenanceWindows = Get-DeviceMaintenanceWindows -DeviceId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/maintenance-windows endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceMaintenanceWindows {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/devices/$DeviceId/maintenance-windows"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            # Check if the response contains data
            if ($response.data) {
                Write-Debug "Successfully retrieved maintenance windows for device $DeviceId"
                return $response.data | ConvertTo-Json -Depth 10
            }
            else {
                Write-Warning "No maintenance windows found for device $DeviceId"
                return $null
            }
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve maintenance windows for device $DeviceId. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                throw "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                throw "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                throw "Device with ID $DeviceId not found."
            }
            else {
                throw "An error occurred while retrieving maintenance windows: $_"
            }
        }
    }
}