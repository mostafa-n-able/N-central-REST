<#
    .SYNOPSIS
    Lists the standard PSA related links.

    .DESCRIPTION
    This function retrieves the standard PSA related links from the N-central API.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the standard PSA related links.

    .NOTES
    This function is part of the N-central API PowerShell module.

    .EXAMPLE
    $result = Get-StandardPsaLinks -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"
    $result

    This example retrieves the standard PSA related links and displays the result.

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/standard-psa endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-StandardPsaLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/standard-psa"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            Write-Debug "Request successful. Processing response."
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode : $statusDescription"
            Write-Debug "Error details: $($_.Exception.Message)"

            if ($statusCode -eq 401) {
                throw "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                throw "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                throw "The requested resource was not found."
            }
            else {
                throw "An error occurred while processing the request. Status code: $statusCode"
            }
        }
    }
}