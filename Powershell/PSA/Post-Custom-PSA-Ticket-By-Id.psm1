<#
    .SYNOPSIS
    Retrieves detailed information for a specific Custom PSA Ticket.

    .DESCRIPTION
    This function sends a POST request to the '/api/custom-psa/tickets/{customPsaTicketId}' endpoint
    to retrieve detailed information about a specific Custom PSA Ticket. It accepts the custom PSA
    ticket ID, PSA credentials, and API connection details as parameters.

    .INPUTS
    - CustomPsaTicketId: The unique identifier of the Custom PSA ticket to retrieve.
    - Username: The username for PSA authentication.
    - Password: The password for PSA authentication.
    - BaseURI: The base URI of the API endpoint.
    - AccessToken: The access token needed for authentication.

    .OUTPUTS
    Returns a JSON object containing the Custom PSA Ticket information.

    .NOTES
    This function is designed for use with the N-central API-Service and is currently in preview stage.

    .EXAMPLE
    $ticketInfo = Get-CustomPsaTicketInfo -CustomPsaTicketId "123456" -Username "user@example.com" -Password "password123" -BaseURI "https://api.example.com" -AccessToken "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/custom-psa/tickets/{customPsaTicketId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-CustomPsaTicketInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CustomPsaTicketId,

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [Parameter(Mandatory = $true)]
        [string]$Password,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "$BaseURI/api/custom-psa/tickets/$CustomPsaTicketId"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }
        $body = @{
            username = $Username
            password = $Password
        } | ConvertTo-Json
    }

    process {
        try {
            Write-Debug "Sending POST request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $body -ErrorAction Stop

            Write-Debug "Request successful. Processing response."
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request: Invalid input format or missing required information." }
                401 { Write-Error "Unauthorized: Authentication failure. Please check your AccessToken." }
                403 { Write-Error "Forbidden: You don't have permission to access this resource." }
                404 { Write-Error "Not Found: The specified Custom PSA Ticket ID does not exist." }
                500 { Write-Error "Internal Server Error: An unexpected error occurred on the server." }
                default { Write-Error "An unexpected error occurred." }
            }

            Write-Debug "Error details: $_"
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