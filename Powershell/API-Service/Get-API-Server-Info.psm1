<#
    .SYNOPSIS
    Retrieves version information of the running API-Service.

    .DESCRIPTION
    This function makes a GET request to the /api/server-info endpoint to retrieve version information about the running API-Service.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing version information of the API-Service.

    .NOTES
    This function requires the BaseURI and AccessToken parameters for authentication.

    .EXAMPLE
    $result = Get-ApiServerInfo -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"
    $result | ConvertTo-Json

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/server-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ApiServerInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "/api/server-info"
        $uri = $BaseURI.TrimEnd('/') + $endpoint
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Making GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            Write-Debug "Request successful. Processing response."
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode : $statusDescription"
            Write-Debug "Error details: $_"

            switch ($statusCode) {
                400 { Write-Error "Bad Request. Please check your input parameters." }
                401 { Write-Error "Authentication failed. Please check your AccessToken." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "Resource not found. Please check the BaseURI." }
                500 { Write-Error "Internal server error. Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }

            return $null
        }
    }

    end {
        if ($response) {
            Write-Debug "Function completed successfully."
        }
        else {
            Write-Debug "Function completed with errors."
        }
    }
}
