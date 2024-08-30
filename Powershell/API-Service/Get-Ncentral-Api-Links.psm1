<#
    .SYNOPSIS
    Retrieves links to other endpoints from the N-central API.

    .DESCRIPTION
    This function makes a GET request to the /api endpoint of the N-central API and returns the links to other endpoints as a JSON object.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing links to other endpoints.

    .NOTES
    This function requires the BaseURI of the API endpoint and a valid AccessToken for authentication.

    .EXAMPLE
    $links = Get-NcentralApiLinks -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"
    $links._links

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-NcentralApiLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "/api"
        $uri = $BaseURI.TrimEnd('/') + $endpoint
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Accept" = "application/json"
        }
    }

    process {
        try {
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

            Write-Debug "Successfully retrieved API links from $uri"
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve API links. Status code: $statusCode - $statusDescription"
            Write-Debug "Error details: $_"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your AccessToken."
            }
            elseif ($statusCode -eq 403) {
                Write-Warning "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "API endpoint not found. Please check the BaseURI."
            }

            return $null
        }
    }
}
