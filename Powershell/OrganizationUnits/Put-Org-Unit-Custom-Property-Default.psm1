<#
    .SYNOPSIS
    Modifies the default organization unit custom property.

    .DESCRIPTION
    This function updates the default organization unit custom property for a given organization unit ID.

    .PARAMETER BaseURI
    The base URI for the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER OrgUnitId
    The ID of the organization unit.

    .PARAMETER DefaultValue
    The default value of the property.

    .PARAMETER EnumeratedValueList
    The list of allowed values for the property, if the property type is ENUMERATED.

    .PARAMETER PropagationType
    The way how the property value changes are propagated down the organization unit hierarchy.

    .PARAMETER PropertyId
    The property id.

    .PARAMETER PropertyName
    The property name.

    .PARAMETER SelectedOrgUnitIds
    The entire list of organization unit IDs to which the custom property is applicable.

    .PARAMETER Propagate
    A boolean flag to specify whether to propagate changes to children Organization Units.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None. This function does not generate any output.

    .NOTES
    This function requires the 'New-HttpQueryString' function to be available in the session.

    .EXAMPLE
    Update-DefaultOrgUnitCustomProperty -BaseURI "https://api.example.com" -AccessToken "your_access_token" -OrgUnitId 123 -PropertyId 456 -PropertyName "CustomProp" -DefaultValue "DefaultVal" -Propagate $true

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/org-units/{orgUnitId}/org-custom-property-defaults endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Update-DefaultOrgUnitCustomProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$DefaultValue,

        [Parameter(Mandatory = $false)]
        [string[]]$EnumeratedValueList,

        [Parameter(Mandatory = $true)]
        [ValidateSet("NO_PROPAGATION", "SERVICE_ORGANIZATION_ONLY", "SERVICE_ORGANIZATION_AND_CUSTOMER_AND_SITE", "SERVICE_ORGANIZATION_AND_CUSTOMER", "SERVICE_ORGANIZATION_AND_SITE", "CUSTOMER_AND_SITE", "CUSTOMER_ONLY", "SITE_ONLY")]
        [string]$PropagationType,

        [Parameter(Mandatory = $true)]
        [int]$PropertyId,

        [Parameter(Mandatory = $true)]
        [string]$PropertyName,

        [Parameter(Mandatory = $true)]
        [int[]]$SelectedOrgUnitIds,

        [Parameter(Mandatory = $true)]
        [bool]$Propagate
    )

    # Construct the full URI
    $uri = "${BaseURI}/api/org-units/${OrgUnitId}/org-custom-property-defaults"

    # Prepare the request body
    $body = @{
        propertyId = $PropertyId
        propertyName = $PropertyName
    }

    if ($PSBoundParameters.ContainsKey('DefaultValue')) { $body.defaultValue = $DefaultValue }
    if ($PSBoundParameters.ContainsKey('EnumeratedValueList')) { $body.enumeratedValueList = $EnumeratedValueList }
    if ($PSBoundParameters.ContainsKey('PropagationType')) { $body.propagationType = $PropagationType }
    if ($PSBoundParameters.ContainsKey('SelectedOrgUnitIds')) { $body.selectedOrgUnitIds = $SelectedOrgUnitIds }
    if ($PSBoundParameters.ContainsKey('Propagate')) { $body.propagate = $Propagate }

    # Convert the body to JSON
    $jsonBody = $body | ConvertTo-Json

    # Prepare the headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $jsonBody -ErrorAction Stop

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP Status Code: $statusCode - $statusDescription"
        Write-Error "Error: $_"

        # You might want to throw the error again if you want to stop the script execution
        throw $_
    }
}