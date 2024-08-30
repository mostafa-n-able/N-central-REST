<#
    .SYNOPSIS
    Authenticates with the N-central API and retrieves access and refresh tokens.

    .DESCRIPTION
    This function takes a JWT token and base URI as input, authenticates with the N-central API,
    and returns the access_token and refresh_token in a dictionary.

    .INPUTS
    - Token: A string containing the JWT token for authentication.
    - BaseUri: A string containing the base URI for the API.

    .OUTPUTS
    A hashtable containing the access_token and refresh_token.

    .NOTES
    This function requires PowerShell 5.1 or later.
    Error handling and logging are implemented for robustness.

    .EXAMPLE
    $result = Get-NcentralAuthTokens -Token "your_jwt_token" -BaseUri "api.example.com"
    $accessToken = $result.access_token
    $refreshToken = $result.refresh_token
#>
function Get-NcentralAuthTokens {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$BaseUri
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $VerbosePreference = 'Continue'

        # Construct the full URI for the authentication endpoint
        $authUri = "$BaseUri/api/auth/authenticate"
        Write-Verbose "Authentication URI: $authUri"
    }

    process {
        try {
            Write-Verbose "Attempting to authenticate with the N-central API..."

            # Prepare the headers for the API request
            $headers = @{
                'Authorization' = "Bearer $Token"
                'Content-Type' = 'application/json'
            }

            # Make the API request
            $response = Invoke-RestMethod -Uri $authUri -Method Post -Headers $headers -ErrorAction Stop

            Write-Verbose "Successfully authenticated with the N-central API."

            # Extract the access and refresh tokens from the response
            $accessToken = $response.tokens.access.token
            $refreshToken = $response.tokens.refresh.token

            # Check if both tokens were received
            if (-not $accessToken -or -not $refreshToken) {
                throw "Failed to retrieve both access and refresh tokens from the API response."
            }

            # Create and return the result hashtable
            $result = @{
                access_token = $accessToken
                refresh_token = $refreshToken
            }

            return $result
        }
        catch {
            Write-Error "An error occurred while authenticating: $_"
            throw
        }
    }

    end {
        Write-Verbose "Authentication process completed."
    }
}
