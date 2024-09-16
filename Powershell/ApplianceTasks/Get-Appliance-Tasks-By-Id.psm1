<#
    .SYNOPSIS
    Retrieves the appliance-task information for a given taskId.

    .DESCRIPTION
    This function makes a GET request to the /api/appliance-tasks/{taskId} endpoint to retrieve
    the appliance-task information for a specified taskId.

    .INPUTS
    - TaskId: The ID of the appliance-task for which information needs to be fetched.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token required for authentication.

    .OUTPUTS
    Returns a JSON object containing the appliance-task information.

    .NOTES
    This function is based on the PREVIEW version of the API endpoint.

    .EXAMPLE
    $taskInfo = Get-ApplianceTaskInformation -TaskId "123456" -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/appliance-tasks/{taskId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ApplianceTaskInformation {
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
        $endpoint = "$BaseURI/api/appliance-tasks/$TaskId"
    }

    process {
        try {
            # Prepare the headers
            $headers = @{
                'Authorization' = "Bearer $AccessToken"
                'Accept' = 'application/json'
            }

            # Make the API request
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ContentType 'application/json'

            # Return the response as a JSON object
            return $response | ConvertTo-Json -Depth 10

        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP Status Code: $statusCode - $statusDescription"

            switch ($statusCode) {
                400 { Write-Error "Bad Request. Please check the provided parameters." }
                401 { Write-Error "Authentication failed. Please check your access token." }
                403 { Write-Error "Forbidden. You don't have permission to access this resource." }
                404 { Write-Error "The specified taskId was not found." }
                500 { Write-Error "Internal Server Error. Please try again later or contact support." }
                default { Write-Error "An unexpected error occurred. StatusCode: $statusCode" }
            }

            # For debugging purposes, output the full error object
            Write-Debug ($_ | ConvertTo-Json -Depth 5)
        }
    }
}