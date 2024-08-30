<#
    .SYNOPSIS
    Creates a new organization unit type access group.

    .DESCRIPTION
    This function creates a new organization unit type access group with the specified details using the POST /api/org-units/{orgUnitId}/access-groups endpoint.

    .INPUTS
    - OrgUnitId: The ID of the organization unit where the access group will be created.
    - GroupName: The name of the access group.
    - GroupDescription: The description of the access group.
    - OrgUnitIds: An array of organization unit IDs to attach to the access group.
    - UserIds: An array of user IDs to be associated with the access group.
    - AutoIncludeNewOrgUnits: A boolean flag indicating whether new org units should be automatically included.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    The function returns the response from the API as a JSON object.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .EXAMPLE
    $result = New-OrgUnitAccessGroup -OrgUnitId 123 -GroupName "New Access Group" -GroupDescription "Description" -OrgUnitIds @(1001, 1002) -UserIds @(5001, 5002) -AutoIncludeNewOrgUnits $true -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/org-units/{orgUnitId}/access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function New-OrgUnitAccessGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$GroupName,

        [Parameter(Mandatory = $true)]
        [string]$GroupDescription,

        [Parameter(Mandatory = $false)]
        [int[]]$OrgUnitIds,

        [Parameter(Mandatory = $false)]
        [int[]]$UserIds,

        [Parameter(Mandatory = $false)]
        [bool]$AutoIncludeNewOrgUnits,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    $ErrorActionPreference = 'Stop'

    try {
        # Construct the endpoint URL
        $endpointUrl = "${BaseURI}/api/org-units/${OrgUnitId}/access-groups"

        # Prepare the request body
        $body = @{
            groupName = $GroupName
            groupDescription = $GroupDescription
        }

        if ($OrgUnitIds) {
            $body.orgUnitIds = $OrgUnitIds
        }

        if ($UserIds) {
            $body.userIds = $UserIds
        }

        if ($PSBoundParameters.ContainsKey('AutoIncludeNewOrgUnits')) {
            $body.autoIncludeNewOrgUnits = $AutoIncludeNewOrgUnits.ToString().ToLower()
        }

        $jsonBody = $body | ConvertTo-Json

        # Prepare the headers
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }

        # Make the API request
        $response = Invoke-RestMethod -Uri $endpointUrl -Method Post -Headers $headers -Body $jsonBody

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10

    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "API request failed with status code $statusCode - $statusDescription"
        
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Debug "Response body: $responseBody"
            $reader.Close()
        }
        
        throw $_
    }
}
