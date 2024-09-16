<#
    .SYNOPSIS
    Retrieves customer information by customer ID.

    .DESCRIPTION
    This function makes a GET request to the /api/customers/{customerId} endpoint to retrieve detailed information about a specific customer.

    .INPUTS
    - CustomerId: The unique identifier of the customer.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing customer information.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .EXAMPLE
    $customerInfo = Get-CustomerById -CustomerId 12345 -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers/{customerId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-CustomerById {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$CustomerId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/customers/${CustomerId}"

        # Set up headers
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }

        Write-Debug "URI: $uri"
        Write-Debug "Headers: $($headers | ConvertTo-Json)"
    }

    process {
        try {
            # Make the API request
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ContentType 'application/json'

            # Return the response
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request - Please check the provided CustomerId and try again." }
                401 { Write-Error "Unauthorized - Please check your AccessToken and try again." }
                403 { Write-Error "Forbidden - You don't have permission to access this resource." }
                404 { Write-Error "Not Found - The specified customer could not be found." }
                500 { Write-Error "Internal Server Error - Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }

            throw
        }
    }
}