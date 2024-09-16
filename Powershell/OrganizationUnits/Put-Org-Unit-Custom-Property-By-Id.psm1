<#
    .SYNOPSIS
    Updates an organization unit custom property.

    .DESCRIPTION
    This function updates a custom property for a specific organization unit using the PUT /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the result of the update operation.

    .NOTES
    This function requires the BaseURI and AccessToken parameters for authentication.

    .EXAMPLE
    Update-OrgUnitCustomProperty -BaseURI "https://api.example.com" -AccessToken "your_access_token" -OrgUnitId 123 -PropertyId 456 -Value "New Property Value"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Update-OrgUnitCustomProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [int]$PropertyId,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $Uri = "${BaseURI}/api/org-units/${OrgUnitId}/custom-properties/${PropertyId}"

        # Prepare the headers
        $Headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }

        # Prepare the body
        $Body = @{
            value = $Value
        } | ConvertTo-Json
    }

    process {
        try {
            Write-Debug "Sending PUT request to $Uri"
            
            $Response = Invoke-RestMethod -Uri $Uri -Method Put -Headers $Headers -Body $Body -ErrorVariable RestError

            Write-Debug "Request successful"
            return $Response
        }
        catch {
            $StatusCode = $_.Exception.Response.StatusCode.value__
            $StatusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $StatusCode $StatusDescription at $Uri"
            
            if ($RestError) {
                Write-Error $RestError.Message
            }
        }
    }
}