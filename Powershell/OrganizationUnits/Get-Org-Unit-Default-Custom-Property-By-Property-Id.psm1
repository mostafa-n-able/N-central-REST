<#
    .SYNOPSIS
    Retrieves the default custom property for an organization unit.

    .DESCRIPTION
    This function retrieves the default custom property for a specific organization unit using the provided organization unit ID and property ID.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the default custom property information.

    .NOTES
    This function requires the BaseURI and AccessToken parameters for authentication.

    .EXAMPLE
    Get-OrgUnitDefaultCustomProperty -OrgUnitId 123 -PropertyId 456 -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/org-custom-property-defaults/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrgUnitDefaultCustomProperty {
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
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/org-units/${OrgUnitId}/org-custom-property-defaults/${PropertyId}"

        # Set up headers
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Accept" = "application/json"
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $uri"

            # Send the GET request
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            # Return the response as a JSON object
            return $response

        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription at $uri"
            
            switch ($statusCode) {
                400 { Write-Error "Bad request. Please check your input parameters." }
                401 { Write-Error "Authentication failed. Please check your access token." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "Resource not found. Please check if the OrgUnitId and PropertyId are correct." }
                500 { Write-Error "Internal server error. Please try again later or contact support." }
                default { Write-Error $_.Exception.Message }
            }
        }
    }
}