<#
    .SYNOPSIS
    Retrieves the registration token for a specified customer.

    .DESCRIPTION
    This function makes a GET request to the N-able N-central API to retrieve the registration token for a given customer ID.

    .PARAMETER CustomerId
    The ID of the customer for which to retrieve the registration token.

    .PARAMETER BaseURI
    The base URI of the N-able N-central API.

    .PARAMETER AccessToken
    The access token required for authentication with the N-able N-central API.

    .OUTPUTS
    Returns a PSObject containing the registration token and its expiry date.

    .NOTES
    This function is part of the N-able N-central API PowerShell module.

    .EXAMPLE
    $token = Get-CustomerRegistrationToken -CustomerId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers/{customerId}/registration-token endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-CustomerRegistrationToken {
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
        $endpoint = "$BaseURI/api/customers/$CustomerId/registration-token"
    }

    process {
        try {
            # Construct the headers
            $headers = @{
                'Authorization' = "Bearer $AccessToken"
                'Content-Type' = 'application/json'
            }

            # Make the API request
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            # Check if the response contains the expected data
            if ($response.data -and $response.data.registrationToken -and $response.data.registrationTokenExpiryDate) {
                # Return the registration token information as a PSObject
                return [PSCustomObject]@{
                    registrationToken = $response.data.registrationToken
                    registrationTokenExpiryDate = $response.data.registrationTokenExpiryDate
                }
            }
            else {
                Write-Error "Unexpected response format from the API."
            }
        }
        catch {
            # Handle specific HTTP status code errors
            switch ($_.Exception.Response.StatusCode.value__) {
                400 { Write-Error "Bad Request: The server cannot process the request due to a client error." }
                401 { Write-Error "Unauthorized: Authentication has failed or has not been provided." }
                403 { Write-Error "Forbidden: The server understood the request but refuses to authorize it." }
                404 { Write-Error "Not Found: The requested resource could not be found." }
                500 { Write-Error "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
                default { Write-Error "An error occurred: $_" }
            }
        }
    }

    end {
        # This block is intentionally left empty as there are no specific end actions required
    }
}