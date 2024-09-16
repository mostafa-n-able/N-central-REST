<#
    .SYNOPSIS
    Retrieves a list of Custom PSA tickets.

    .DESCRIPTION
    This function sends a GET request to the /api/custom-psa/tickets endpoint to retrieve a list of Custom PSA tickets.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the list of Custom PSA tickets.

    .NOTES
    This function requires a valid BaseURI and AccessToken for authentication.

    .EXAMPLE
    $tickets = Get-CustomPsaTickets -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/custom-psa/tickets endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-CustomPsaTickets {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $Headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
        $Endpoint = "$BaseURI/api/custom-psa/tickets"
    }

    process {
        try {
            Write-Debug "Sending GET request to $Endpoint"
            $Response = Invoke-RestMethod -Uri $Endpoint -Headers $Headers -Method Get

            Write-Debug "Request successful. Processing response."
            return $Response | ConvertTo-Json -Depth 10
        }
        catch {
            $StatusCode = $_.Exception.Response.StatusCode.value__
            $StatusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $StatusCode - $StatusDescription"
            Write-Error "Error details: $_"

            # You might want to handle specific status codes differently
            switch ($StatusCode) {
                401 { Write-Warning "Authentication failed. Please check your AccessToken." }
                403 { Write-Warning "You don't have permission to access this resource." }
                404 { Write-Warning "The requested resource was not found." }
                500 { Write-Warning "An internal server error occurred. Please try again later." }
            }
        }
    }

    end {
        Write-Debug "Function Get-CustomPsaTickets completed."
    }
}