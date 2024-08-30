<#
    .SYNOPSIS
    Retrieves a list of access groups.

    .DESCRIPTION
    This function retrieves a list of access groups using the GET /api/access-groups endpoint of the N-central API.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the list of access groups and related information.

    .NOTES
    This function requires a valid BaseURI and AccessToken to authenticate with the API.

    .EXAMPLE
    $result = Get-AccessGroupsEndpoints -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-AccessGroupsEndpoints {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "/api/access-groups"
        $uri = $BaseURI.TrimEnd('/') + $endpoint

        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }

        Write-Debug "BaseURI: $BaseURI"
        Write-Debug "Endpoint: $endpoint"
        Write-Debug "Full URI: $uri"
    }

    process {
        try {
            Write-Debug "Sending GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

            Write-Debug "Request successful. Processing response."
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode : $statusDescription"
            Write-Debug "Error details: $_"

            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $responseBody = $reader.ReadToEnd()
                Write-Debug "Response body: $responseBody"
                $reader.Close()
            }

            throw $_
        }
    }
}
