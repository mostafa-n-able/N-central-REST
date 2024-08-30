<#
    .SYNOPSIS
    Adds a new user role for a given organization unit.

    .DESCRIPTION
    This function creates a new user role for a specified organization unit using the N-central API.
    It sends a POST request to the /api/org-units/{orgUnitId}/user-roles endpoint with the provided parameters.

    .INPUTS
    - BaseURI: The base URI of the API endpoint
    - AccessToken: The access token for authentication
    - OrgUnitId: The ID of the organization unit
    - RoleName: The name of the new role
    - Description: The description of the new role
    - PermissionIds: An array of permission IDs for the new role
    - UserIds: An optional array of user IDs to associate with the new role

    .OUTPUTS
    Returns a JSON object containing the response from the API, including the new role ID.

    .CLASSIFICATION
    Destructive: Yes
    Potentially Long Running: No

    .NOTES
    This function requires PowerShell 5.1 or later.
    Error handling is implemented to catch and report any issues during the API call.

    .EXAMPLE
    $result = Add-UserRole -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -OrgUnitId 123 -RoleName "New Role" -Description "Description of new role" -PermissionIds @(1, 2, 3) -UserIds @(101, 102)
#>
function Add-UserRole {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$RoleName,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [int[]]$PermissionIds,

        [Parameter(Mandatory = $true)]
        [int[]]$UserIds
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/org-units/${OrgUnitId}/user-roles"

        # Prepare the headers
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }

        # Prepare the body
        $body = @{
            roleName = $RoleName
            description = $Description
            permissionIds = $PermissionIds
        }

        if ($UserIds) {
            $body['userIds'] = $UserIds
        }

        $jsonBody = $body | ConvertTo-Json

        Write-Debug "URI: $uri"
        Write-Debug "Headers: $($headers | Out-String)"
        Write-Debug "Body: $jsonBody"
    }

    process {
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $jsonBody -ErrorAction Stop

            Write-Debug "Raw API Response: $($response | ConvertTo-Json -Depth 5)"

            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Error details: $_.Exception.Response"
            Write-Error "API call failed with status code $statusCode : $statusDescription"
            Write-Error "Error details: $_.Exception.Response"

            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $responseBody = $reader.ReadToEnd()
                Write-Error "Response body: $responseBody"
                $reader.Close()
            }

            throw
        }
    }
}