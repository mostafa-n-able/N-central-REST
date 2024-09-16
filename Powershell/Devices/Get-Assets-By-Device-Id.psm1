<#
    .SYNOPSIS
    Retrieves asset information for a specific device.

    .DESCRIPTION
    This function calls the GET /api/devices/{deviceId}/assets endpoint to retrieve complete asset information for a device with a specific ID.

    .PARAMETER DeviceId
    The ID of the device for which to retrieve asset information.

    .PARAMETER BaseURI
    The base URI of the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .OUTPUTS
    Returns a JSON object containing the device's asset information.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .EXAMPLE
    $assetInfo = Get-DeviceAssetInfo -DeviceId 123456 -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/assets endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceAssetInfo {
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
        $endpoint = "$BaseURI/api/devices/$DeviceId/assets"
    }

    process {
        try {
            $headers = @{
                'Authorization' = "Bearer $AccessToken"
                'Accept' = 'application/json'
            }

            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            Write-Debug "Successfully retrieved asset information for device $DeviceId"
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve asset information for device $DeviceId. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Device with ID $DeviceId not found."
            }
            elseif ($statusCode -eq 500) {
                Write-Warning "Internal server error occurred. Please try again later or contact support."
            }

            throw $_
        }
    }
}