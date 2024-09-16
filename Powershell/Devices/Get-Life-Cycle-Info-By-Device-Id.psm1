<#
    .SYNOPSIS
    Retrieves asset lifecycle information for a specific device.

    .DESCRIPTION
    This function makes a GET request to the '/api/devices/{deviceId}/assets/lifecycle-info' endpoint
    to retrieve asset lifecycle information for a given device ID.

    .INPUTS
    - DeviceId: The ID of the device for which to retrieve asset lifecycle information.
    - BaseURI: The base URI of the API endpoint.
    - AccessToken: The access token needed for authentication.

    .OUTPUTS
    Returns a JSON object containing the asset lifecycle information for the specified device.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .EXAMPLE
    $assetInfo = Get-DeviceAssetLifecycleInfo -DeviceId "123456" -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/assets/lifecycle-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceAssetLifecycleInfo {
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
        $endpoint = "/api/devices/$DeviceId/assets/lifecycle-info"
        $uri = $BaseURI.TrimEnd('/') + $endpoint
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            Write-Debug "Response received successfully"
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription : $($_.Exception.Message)"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Device with ID $DeviceId not found."
            }
        }
    }
}