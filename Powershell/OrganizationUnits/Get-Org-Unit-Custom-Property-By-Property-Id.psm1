<#
    .SYNOPSIS
    Retrieves a custom property for a specific organization unit.

    .DESCRIPTION
    This function makes a GET request to the /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint
    to retrieve details of a specific custom property for a given organization unit.

    .INPUTS
    - OrgUnitId: The ID of the organization unit.
    - PropertyId: The ID of the custom property.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the custom property details.

    .NOTES
    This function is based on the N-able API-Service OpenAPI specification.

    .EXAMPLE
    Get-OrgUnitCustomProperty -OrgUnitId 123 -PropertyId 456 -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrgUnitCustomProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [int]$PropertyId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/org-units/$OrgUnitId/custom-properties/$PropertyId"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Making GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            Write-Debug "Successfully retrieved custom property details"
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve custom property details. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                throw "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                throw "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                throw "Custom Property not found. Please check the OrgUnitId and PropertyId."
            }
            else {
                throw "An error occurred while retrieving the custom property details: $_"
            }
        }
    }
}