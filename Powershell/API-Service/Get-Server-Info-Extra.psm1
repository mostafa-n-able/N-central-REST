<#
    .SYNOPSIS
    Retrieves extra information about the version of different systems in N-central.

    .DESCRIPTION
    This function makes a GET request to the /api/server-info/extra endpoint to retrieve extra information about the version of different systems in N-central.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the version information of different systems in N-central.

    .NOTES
    This endpoint is currently in a preview stage.

    .EXAMPLE
    $result = Get-NCentralServerInfoExtra -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"
    $result.data

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/server-info/extra endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-NCentralServerInfoExtra {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "/api/server-info/extra"
        $uri = $BaseURI.TrimEnd('/') + $endpoint
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Accept" = "application/json"
        }
    }

    process {
        try {
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

            Write-Debug "Successfully retrieved server info extra data"
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve server info extra data. Status code: $statusCode - $statusDescription"
            
            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                Write-Warning "Access forbidden. Please check your permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Endpoint not found. Please check the BaseURI."
            }

            throw $_
        }
    }
}
