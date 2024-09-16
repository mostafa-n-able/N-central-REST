<#
    .SYNOPSIS
    Retrieves information for a specific device by its ID.

    .DESCRIPTION
    This function makes a GET request to the /api/devices/{deviceId} endpoint to retrieve detailed information about a device using its unique identifier.

    .INPUTS
    - DeviceId: The unique identifier of the device.
    - BaseURI: The base URI of the API endpoint.
    - AccessToken: The access token needed for authentication.

    .OUTPUTS
    Returns a JSON object containing the device information.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .EXAMPLE
    $deviceInfo = Get-DeviceById -DeviceId 123456 -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceById {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/devices/${DeviceId}"

        # Set up headers
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }

        Write-Debug "URI: $uri"
        Write-Debug "Headers: $($headers | ConvertTo-Json -Compress)"
    }

    process {
        try {
            # Make the API request
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ContentType 'application/json'

            # Return the response
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request - Please check the provided DeviceId and try again." }
                401 { Write-Error "Unauthorized - Please check your AccessToken and try again." }
                403 { Write-Error "Forbidden - You don't have permission to access this resource." }
                404 { Write-Error "Not Found - The specified DeviceId was not found." }
                500 { Write-Error "Internal Server Error - Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. Please try again or contact support." }
            }

            # Optionally, you can re-throw the exception if you want to halt the script execution
            # throw
        }
    }
}