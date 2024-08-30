<#
    .SYNOPSIS
    Retrieves information about an organization unit by its ID.

    .DESCRIPTION
    This function makes a GET request to the /api/org-units/{orgunitId} endpoint of the N-central API
    to retrieve detailed information about a specific organization unit.

    .INPUTS
    - orgUnitId: The ID of the organization unit to retrieve (required).
    - BaseURI: The base URI of the API endpoint (required).
    - AccessToken: The access token for authentication (required).

    .OUTPUTS
    Returns a JSON object containing the organization unit information.

    .NOTES
    This function requires PowerShell 5.1 or later.
    Make sure you have the necessary permissions to access the API.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: Yes

    .EXAMPLE
    $result = Get-OrganizationUnit -orgUnitId 123 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"
    $result | ConvertTo-Json -Depth 5
#>
function Get-OrganizationUnit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$orgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/org-units/${orgUnitId}"

        # Set up headers
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }

        Write-Debug "URI: $uri"
        Write-Debug "Headers: $($headers | ConvertTo-Json -Compress)"
    }

    process {
        try {
            Write-Verbose "Sending GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorVariable responseError

            Write-Debug "Response received: $($response | ConvertTo-Json -Depth 5 -Compress)"

            # Return the response data
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription at $uri"
            Write-Debug "Full Error: $_"

            if ($responseError) {
                Write-Error "Error details: $($responseError.Message)"
            }

            # You might want to throw the error again if you want to stop the script execution
            # throw
        }
    }

    end {
        Write-Verbose "Get-OrganizationUnit function completed."
    }
}