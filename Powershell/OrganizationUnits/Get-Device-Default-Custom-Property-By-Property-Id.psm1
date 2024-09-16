<#
    .SYNOPSIS
    Retrieves default custom properties information for a device.

    .DESCRIPTION
    This function retrieves the default custom properties information for a device using the specified organization unit ID and property ID.

    .INPUTS
    - OrgUnitId: The ID of the organization unit.
    - PropertyId: The ID of the property.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the device custom property information.

    .NOTES
    This function is based on the PREVIEW endpoint GET /api/org-units/{orgUnitId}/custom-properties/device-custom-property-defaults/{propertyId}

    .EXAMPLE
    $result = Get-DeviceDefaultCustomProperty -OrgUnitId 123 -PropertyId 456 -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/custom-properties/device-custom-property-defaults/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceDefaultCustomProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$PropertyId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/org-units/${OrgUnitId}/custom-properties/device-custom-property-defaults/${PropertyId}"

        # Set up headers
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }

        Write-Debug "URI: $uri"
        Write-Debug "Headers: $($headers | ConvertTo-Json)"
    }

    process {
        try {
            # Make the API request
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorVariable responseError

            # Return the response
            return $response

        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription : $responseError"

            # Handle specific error cases
            switch ($statusCode) {
                400 { Write-Error "Bad Request: Please check the provided parameters." }
                401 { Write-Error "Unauthorized: Please check your access token." }
                403 { Write-Error "Forbidden: You don't have permission to access this resource." }
                404 { Write-Error "Not Found: The specified organization unit or property was not found." }
                500 { Write-Error "Internal Server Error: Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }

            # Re-throw the exception for further handling if needed
            throw
        }
    }

    end {
        # This block intentionally left empty
    }
}