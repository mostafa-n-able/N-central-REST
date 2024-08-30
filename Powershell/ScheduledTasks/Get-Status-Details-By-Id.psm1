<#
    .SYNOPSIS
    Retrieves detailed status per device for a given task.

    .DESCRIPTION
    This function retrieves a list of detailed statuses for each device associated with the given task using the task ID.

    .INPUTS
    - TaskId: The ID of the task for which detailed status needs to be fetched.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the detailed status per device for the given task.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: No

    .EXAMPLE
    $result = Get-TaskStatusDetails -TaskId "123456" -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks/{taskId}/status/details endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-TaskStatusDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$TaskId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/scheduled-tasks/${TaskId}/status/details"

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

            # Return the response as a JSON object
            return $response | ConvertTo-Json -Depth 10

        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request: The server cannot process the request due to a client error." }
                401 { Write-Error "Unauthorized: Authentication has failed or has not been provided." }
                403 { Write-Error "Forbidden: The server understood the request but refuses to authorize it." }
                404 { Write-Error "Not Found: The requested resource could not be found." }
                500 { Write-Error "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
                default { Write-Error "An unexpected error occurred." }
            }

            # Optionally, you can return a custom error object
            return @{
                Error = $true
                StatusCode = $statusCode
                Message = $_.Exception.Message
            } | ConvertTo-Json
        }
    }

    end {
        # Clean up if necessary
    }
}