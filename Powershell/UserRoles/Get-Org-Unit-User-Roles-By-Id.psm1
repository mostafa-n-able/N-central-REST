<#
    .SYNOPSIS
    Retrieves a user role for a given organization unit and user role id.

    .DESCRIPTION
    This function makes a GET request to the /api/org-units/{orgUnitId}/user-roles/{userRoleId} endpoint
    to retrieve details of a specific user role within an organization unit.

    .INPUTS
    - BaseURI: The base URI of the API endpoint
    - AccessToken: The access token for authentication
    - OrgUnitId: The ID of the organization unit
    - UserRoleId: The ID of the user role

    .OUTPUTS
    Returns a JSON object containing the user role details.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: No

    .NOTES
    This function is based on the PREVIEW version of the API endpoint.

    .EXAMPLE
    $result = Get-UserRole -BaseURI "https://api.example.com" -AccessToken "your_access_token" -OrgUnitId 123 -UserRoleId 456
#>
function Get-UserRole {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [string]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$UserRoleId
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/org-units/${OrgUnitId}/user-roles/${UserRoleId}"

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
            Write-Verbose "Sending GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ContentType 'application/json'

            Write-Debug "Response received: $($response | ConvertTo-Json -Depth 5)"

            # Return the response as a JSON object
            return $response | ConvertTo-Json -Depth 5
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "API request failed with status code $statusCode : $statusDescription"
            Write-Debug "Error details: $_"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                Write-Warning "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Resource not found. Please check the OrgUnitId and UserRoleId."
            }

            throw $_
        }
    }

    end {
        Write-Verbose "Get-UserRole function completed."
    }
}