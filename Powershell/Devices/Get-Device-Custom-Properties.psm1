<#
    .SYNOPSIS
    Retrieves custom properties for a specific device.

    .DESCRIPTION
    This function retrieves the list of custom properties for a given device using its device ID.

    .PARAMETER DeviceId
    The ID of the device for which to retrieve custom properties.

    .PARAMETER BaseURI
    The base URI of the API endpoint.

    .PARAMETER AccessToken
    The access token needed for authentication.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of custom properties for the specified device.

    .NOTES
    This function is based on the PREVIEW endpoint and may be subject to changes.

    .EXAMPLE
    $properties = Get-DeviceCustomProperties -DeviceId 123456 -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/custom-properties endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceCustomProperties {
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
        $endpoint = "/api/devices/$DeviceId/custom-properties"
        $uri = $BaseURI.TrimEnd('/') + $endpoint

        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }

        Write-Debug "Endpoint URI: $uri"
        Write-Debug "Headers: $($headers | ConvertTo-Json)"
    }

    process {
        try {
            Write-Debug "Sending GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            Write-Debug "Response received: $($response | ConvertTo-Json -Depth 5)"

            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Error ${statusCode}: ${statusDescription}"
            Write-Debug "Error details: $($_.Exception.Message)"

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
                throw "An error occurred while retrieving custom properties: $($_.Exception.Message)"
            }
        }
    }

    end {
        Write-Debug "Function Get-DeviceCustomProperties completed."
    }
}
