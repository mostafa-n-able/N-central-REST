<#
    .SYNOPSIS
    Retrieves the registration token for a specific site.

    .DESCRIPTION
    This function makes a GET request to the /api/sites/{siteId}/registration-token endpoint
    to retrieve the registration token for a given site ID.

    .INPUTS
    - SiteId: The ID of the site for which to retrieve the registration token.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the registration token information.

    .NOTES
    This function is part of the N-able N-central API PowerShell module.

    .EXAMPLE
    $token = Get-SiteRegistrationToken -SiteId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/sites/{siteId}/registration-token endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-SiteRegistrationToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/sites/$SiteId/registration-token"
    }

    process {
        try {
            # Set up headers
            $headers = @{
                'Authorization' = "Bearer $AccessToken"
                'Content-Type' = 'application/json'
            }

            # Make the API request
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            # Return the response as a JSON object
            return $response | ConvertTo-Json -Depth 10

        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request - Please check the provided parameters." }
                401 { Write-Error "Unauthorized - Please check your access token." }
                403 { Write-Error "Forbidden - You don't have permission to access this resource." }
                404 { Write-Error "Not Found - The specified site ID was not found." }
                500 { Write-Error "Internal Server Error - Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }

            # Re-throw the original exception
            throw
        }
    }

    end {
        # Nothing to clean up
    }
}