<#
    .SYNOPSIS
    Lists the custom PSA related links.

    .DESCRIPTION
    This function retrieves a list of custom PSA related links from the N-central API.

    .PARAMETER BaseURI
    The base URI for the N-central API.

    .PARAMETER AccessToken
    The access token required for authentication.

    .OUTPUTS
    Returns a PSObject containing the custom PSA related links.

    .NOTES
    This endpoint is currently in a preview stage.

    .EXAMPLE
    $links = Get-CustomPsaLinks -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/custom-psa endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-CustomPsaLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "$BaseURI/api/custom-psa"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            # Make the API request
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ErrorAction Stop

            # Convert the response to JSON
            $jsonResponse = $response | ConvertTo-Json -Depth 10

            # Return the JSON response
            return $jsonResponse
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request. Please check your input parameters." }
                401 { Write-Error "Unauthorized. Please check your access token." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "Not Found. The requested resource was not found." }
                500 { Write-Error "Internal Server Error. Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }

            # Log the full error for debugging
            Write-Debug "Full Error: $_"
        }
    }
}