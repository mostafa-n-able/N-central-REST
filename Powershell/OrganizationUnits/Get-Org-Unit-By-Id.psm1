<#
    .SYNOPSIS
    Retrieves information about a specific organization unit.

    .DESCRIPTION
    This function makes a GET request to the /api/org-units/{orgUnitId} endpoint to retrieve details about a specific organization unit.

    .INPUTS
    - OrgUnitId: The ID of the organization unit to retrieve.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the organization unit details.

    .NOTES
    This function is based on the N-central API-Service version 1.0.

    .EXAMPLE
    $orgUnitInfo = Get-OrganizationUnit -OrgUnitId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrganizationUnit {
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
        $endpoint = "$BaseURI/api/org-units/$OrgUnitId"
    }

    process {
        try {
            # Prepare the headers
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
                400 { Write-Debug "Bad Request: The server cannot or will not process the request due to an apparent client error." }
                401 { Write-Debug "Unauthorized: Authentication is required and has failed or has not been provided." }
                403 { Write-Debug "Forbidden: The server understood the request but refuses to authorize it." }
                404 { Write-Debug "Not Found: The requested resource could not be found." }
                500 { Write-Debug "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
                default { Write-Debug "An error occurred: $_" }
            }

            throw $_
        }
    }

    end {
        # Nothing to clean up
    }
}