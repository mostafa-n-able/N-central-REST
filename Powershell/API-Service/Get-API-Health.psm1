<#
    .SYNOPSIS
    Retrieves the health status of the API service.

    .DESCRIPTION
    This function makes a GET request to the /api/health endpoint to retrieve the current time of the server,
    indicating that the API service is running and healthy.

    .INPUTS
    None

    .OUTPUTS
    PSCustomObject containing the current time of the server.

    .NOTES

    .EXAMPLE
    $health = Get-ApiHealth -BaseURI "https://api.example.com"
    $health.currentTime

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/health endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ApiHealth {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/health"

        # Set up headers
        $headers = @{
            'Accept' = 'application/json'
        }

        Write-Debug "Initiating API health check request to: $uri"
    }

    process {
        try {
            # Make the API request
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            Write-Debug "API health check request successful"
            
            # Return the response as a PSCustomObject
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "API request failed. Status code: $statusCode. Description: $statusDescription"

            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $responseBody = $reader.ReadToEnd()
                Write-Debug "Response body: $responseBody"
                $reader.Close()
            }

            throw
        }
    }

    end {
        if ($response) {
            Write-Debug "API health check completed. Current server time: $($response.currentTime)"
        }
    }
}
