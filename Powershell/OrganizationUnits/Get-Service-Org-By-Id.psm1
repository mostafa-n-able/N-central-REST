<#
    .SYNOPSIS
    Retrieves detailed information for a specific Service Organization by ID.

    .DESCRIPTION
    This function makes a GET request to the /api/service-orgs/{soId} endpoint to retrieve
    information about a specific Service Organization. It returns the data as a JSON object.

    .PARAMETER SoId
    The unique identifier of the service organization for which information is being requested.

    .PARAMETER BaseURI
    The base URI of the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the service organization details.

    .NOTES
    This function is based on the PREVIEW endpoint and may be subject to changes.

    .EXAMPLE
    Get-ServiceOrganization -SoId 123 -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/service-orgs/{soId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ServiceOrganization {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$SoId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/service-orgs/$SoId"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Making GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            # Return the response data
            return $response

        } catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode : $statusDescription"
            
            switch ($statusCode) {
                400 { Write-Error "Bad Request. Please check the provided SoId." }
                401 { Write-Error "Authentication failed. Please check your access token." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "Service Organization with ID $SoId not found." }
                500 { Write-Error "Internal Server Error. Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. StatusCode: $statusCode" }
            }
        }
    }
}