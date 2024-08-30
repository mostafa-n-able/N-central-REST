<#
    .SYNOPSIS
    Lists the authentication-related links.

    .DESCRIPTION
    This function retrieves a list of authentication-related links from the N-central API.

    .INPUTS
    None

    .OUTPUTS
    PSObject. A custom object containing the authentication-related links.

    .NOTES
    This function requires a valid BaseURI and AccessToken to authenticate with the N-central API.

    .EXAMPLE
    $links = Get-AuthLinks -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"
    This example retrieves the authentication-related links and displays them.

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/auth endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-AuthLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "/api/auth"
        $uri = $BaseURI.TrimEnd('/') + $endpoint
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }
    }

    process {
        try {
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

            # Convert the response to JSON
            $jsonResponse = $response | ConvertTo-Json -Depth 10

            # Create a custom object with the JSON response
            $result = [PSCustomObject]@{
                Links = $response._links
                RawJSON = $jsonResponse
            }

            return $result
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"
            Write-Error "Error details: $_"

            # You might want to throw the error again if you want to stop the execution
            # throw $_
        }
    }

    end {
        # Nothing to clean up
    }
}
