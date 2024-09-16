<#
    .SYNOPSIS
    Retrieves the status of service monitoring tasks for a given device.

    .DESCRIPTION
    This function calls the GET /api/devices/{deviceId}/service-monitor-status endpoint to retrieve the status of service monitoring tasks for a specified device.

    .INPUTS
    - DeviceId: The ID of the device for which to retrieve service monitoring status.
    - BaseURI: The base URI of the API endpoint.
    - AccessToken: The access token needed for authentication.

    .OUTPUTS
    Returns a JSON object containing the service monitoring status information for the specified device.

    .NOTES
    This function is based on the N-central API-Service version 1.0.

    .EXAMPLE
    $status = Get-DeviceServiceMonitorStatus -DeviceId "123456" -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/service-monitor-status endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceServiceMonitorStatus {
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
        $endpoint = "$BaseURI/api/devices/$DeviceId/service-monitor-status"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Accept" = "application/json"
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            # Check if the response contains data
            if ($response.data) {
                Write-Debug "Successfully retrieved service monitoring status for device $DeviceId"
                return $response.data | ConvertTo-Json -Depth 10
            } else {
                Write-Warning "No service monitoring status data found for device $DeviceId"
                return $null
            }
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Error accessing the API. Status code: $statusCode - $statusDescription"
            
            if ($statusCode -eq 401) {
                Write-Error "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                Write-Error "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Error "Device with ID $DeviceId not found."
            }
            else {
                Write-Error "An unexpected error occurred. Error details: $_"
            }
        }
    }

    end {
        # Nothing to clean up
    }
}