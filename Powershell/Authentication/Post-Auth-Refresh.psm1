<#
    .SYNOPSIS
    Obtains a new API-Access token using a valid refresh token.

    .DESCRIPTION
    This function refreshes the API-Access token by sending a POST request to the /api/auth/refresh endpoint.
    It requires a valid refresh token and returns a new set of access and refresh tokens.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the new access and refresh tokens.

    .NOTES
    This function is part of a module for interacting with the N-central API.

    .EXAMPLE
    $result = Invoke-NcentralAuthRefresh -RefreshToken "your_refresh_token" -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/auth/refresh endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Invoke-NcentralAuthRefresh {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RefreshToken,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [string]$AccessExpiryOverride,

        [Parameter(Mandatory = $false)]
        [string]$RefreshExpiryOverride
    )

    begin {
        $endpoint = "$BaseURI/api/auth/refresh"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "text/plain"
        }

        # Add optional headers if provided
        if ($AccessExpiryOverride) {
            $headers["X-ACCESS-EXPIRY-OVERRIDE"] = $AccessExpiryOverride
        }
        if ($RefreshExpiryOverride) {
            $headers["X-REFRESH-EXPIRY-OVERRIDE"] = $RefreshExpiryOverride
        }

        Write-Debug "Endpoint: $endpoint"
        Write-Debug "Headers: $($headers | ConvertTo-Json -Compress)"
    }

    process {
        try {
            $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $RefreshToken -ErrorVariable responseError

            # Convert the response to JSON
            $jsonResponse = $response | ConvertTo-Json -Depth 10

            Write-Debug "Response: $jsonResponse"

            return $jsonResponse
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription at $endpoint"
            Write-Debug "Error details: $($_.Exception.Message)"

            if ($responseError) {
                Write-Debug "Response error: $responseError"
            }

            throw $_
        }
    }
}
