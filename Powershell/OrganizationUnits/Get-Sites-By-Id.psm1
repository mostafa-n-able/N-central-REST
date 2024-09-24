<#
    .SYNOPSIS
    Retrieves detailed information for a specific site.

    .DESCRIPTION
    This function makes a GET request to the /api/sites/{siteId} endpoint to retrieve
    detailed information about a specific site in N-central.

    .INPUTS
    - SiteId: The unique identifier of the site.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token required for authentication.

    .OUTPUTS
    Returns a JSON object containing the site information.

    .NOTES
    This function is based on the N-central API specification version 1.0.

    .EXAMPLE
    $siteInfo = Get-Site-By-Id -SiteId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/sites/{siteId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-Site-By-Id {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "$BaseURI/api/sites/$SiteId"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Accept" = "application/json"
        }
    }

    process {
        try {
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ErrorAction Stop

            Write-Debug "Successfully retrieved site information for SiteId: $SiteId"
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve site information. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your AccessToken."
            }
            elseif ($statusCode -eq 403) {
                Write-Warning "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Site with ID $SiteId not found."
            }

            Write-Debug "Error details: $_"
        }
    }
}