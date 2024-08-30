<#
    .SYNOPSIS
    Retrieves detailed information for a specific Access Group by ID.

    .DESCRIPTION
    This function calls the N-central API to get detailed information about a specific Access Group, including its name, type, and associated devices or users.

    .INPUTS
    - AccessGroupId: The unique identifier of the access group for which information is being requested.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token required for authentication.

    .OUTPUTS
    Returns a JSON object containing the access group information.

    .NOTES
    This function is based on the PREVIEW endpoint and may be subject to changes.

    .EXAMPLE
    $accessGroupInfo = Get-AccessGroup-By-Id -AccessGroupId "1234" -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the Get /api/access-groups/{accessGroupId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-AccessGroup-By-Id {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AccessGroupId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/access-groups/$AccessGroupId"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            if ($response) {
                Write-Debug "Successfully retrieved access group information"
                return $response | ConvertTo-Json -Depth 10
            }
            else {
                Write-Warning "No data returned from the API"
                return $null
            }
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve access group information. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                Write-Error "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                Write-Error "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Error "Access group not found. Please check the AccessGroupId."
            }
            elseif ($statusCode -eq 500) {
                Write-Error "Internal server error. Please try again later or contact support."
            }

            throw $_
        }
    }

    end {
        # Nothing to clean up
    }
}
