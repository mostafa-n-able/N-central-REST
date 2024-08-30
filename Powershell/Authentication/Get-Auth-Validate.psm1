<#
    .SYNOPSIS
    Validates the API-Access token.

    .DESCRIPTION
    This function checks the validity of the API-Access token by making a GET request to the /api/auth/validate endpoint.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the validation message.

    .NOTES
    This function requires an active API-Access token to be provided.

    .EXAMPLE
    $result = Get-AuthValidate -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"
    $result

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/auth/validate endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-AuthValidate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        $endpoint = "$BaseURI/api/auth/validate"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }

        Write-Debug "Endpoint: $endpoint"
        Write-Debug "Headers: $($headers | ConvertTo-Json -Compress)"
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            Write-Debug "Response received: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"
            Write-Error "Error details: $_"

            switch ($statusCode) {
                400 { Write-Error "Bad Request. Please check your input parameters." }
                401 { Write-Error "Authentication Failure. Please check your AccessToken." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "Not Found. The requested resource does not exist." }
                500 { Write-Error "Internal Server Error. Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }
        }
    }

    end {
        Write-Debug "Function Get-AuthValidate completed."
    }
}
