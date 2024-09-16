<#
    .SYNOPSIS
    Validates credentials for a standard PSA system.

    .DESCRIPTION
    This function validates the credentials for a standard PSA system using the POST /api/standard-psa/{psaType}/credential endpoint.
    It accepts the PSA type, username, password, base URI, and access token as parameters.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the validation result.

    .NOTES
    Currently, this endpoint only supports Tigerpaw (psaType = 3) and is in preview stage.

    .EXAMPLE
    $result = Invoke-ValidatePsaCredentials -PsaType "3" -Username "user@example.com" -Password "password123" -BaseUri "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/standard-psa/{psaType}/credential endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Invoke-ValidatePsaCredentials {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$PsaType,

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [Parameter(Mandatory = $true)]
        [string]$Password,

        [Parameter(Mandatory = $true)]
        [string]$BaseUri,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "/api/standard-psa/$PsaType/credential"
        $uri = $BaseUri.TrimEnd('/') + $endpoint

        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }

        $body = @{
            username = $Username
            password = $Password
        } | ConvertTo-Json
    }

    process {
        try {
            Write-Debug "Sending POST request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body

            Write-Debug "Request successful. Processing response."
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request: Missing required information (psaType, psaUsername, psaPassword)" }
                401 { Write-Error "Unauthorized: Authentication failure" }
                403 { Write-Error "Forbidden: Access denied" }
                404 { Write-Error "Not Found: PSA type not found" }
                500 { Write-Error "Internal Server Error: Unexpected error occurred" }
                default { Write-Error "An unexpected error occurred" }
            }

            throw $_
        }
    }
}