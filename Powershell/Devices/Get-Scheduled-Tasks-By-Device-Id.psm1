<#
    .SYNOPSIS
    Retrieves scheduled tasks for a specific device.

    .DESCRIPTION
    This function retrieves a list of scheduled tasks associated with a specified device using the device ID.

    .PARAMETER BaseURI
    The base URI for the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER DeviceId
    The ID of the device for which to retrieve scheduled tasks.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of scheduled tasks for the specified device.

    .NOTES
    This function requires the New-HttpQueryString function to be available in the environment.

    .EXAMPLE
    $tasks = Get-DeviceScheduledTasks -BaseURI "https://api.example.com" -AccessToken "your_access_token" -DeviceId 12345

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/scheduled-tasks endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceScheduledTasks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [string]$DeviceId
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/devices/$DeviceId/scheduled-tasks"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            Write-Debug "Successfully retrieved scheduled tasks for device $DeviceId"
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve scheduled tasks for device $DeviceId. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                Write-Warning "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Device with ID $DeviceId not found."
            }

            throw $_
        }
    }
}