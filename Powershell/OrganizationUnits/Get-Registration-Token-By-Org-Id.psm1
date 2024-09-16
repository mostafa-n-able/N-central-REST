<#
    .SYNOPSIS
    Retrieves the registration token for a specified organization unit.

    .DESCRIPTION
    This function makes a GET request to the N-able N-central API to retrieve the registration token
    for a given organization unit. It requires the organization unit ID, base URI of the API, and a valid access token.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the registration token information.

    .NOTES
    This function is part of the N-able N-central API PowerShell module.

    .EXAMPLE
    Get-NCentralOrgUnitRegistrationToken -OrgUnitId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/registration-token endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-NCentralOrgUnitRegistrationToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/org-units/$OrgUnitId/registration-token"
    }

    process {
        try {
            # Set up headers for the API request
            $headers = @{
                'Authorization' = "Bearer $AccessToken"
                'Content-Type' = 'application/json'
            }

            # Make the API request
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            # Return the response as a JSON object
            return $response

        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request. Please check the provided parameters." }
                401 { Write-Error "Authentication failed. Please check your access token." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "Organization unit with ID $OrgUnitId not found." }
                500 { Write-Error "Internal Server Error. Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }
        }
    }
}