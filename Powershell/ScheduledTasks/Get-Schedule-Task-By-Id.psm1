<#
    .SYNOPSIS
    Retrieves general information for a given task.

    .DESCRIPTION
    This function retrieves general information for a given task using the task ID.

    .PARAMETER TaskId
    The ID of the task for which information is to be retrieved.

    .PARAMETER BaseURI
    The base URI for the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the task information.

    .NOTES
    This function requires PowerShell 3.0 or later.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: No

    .EXAMPLE
    Get-ScheduledTaskInfo -TaskId "123456" -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks/{taskId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ScheduledTaskInfo {
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
        $endpoint = "$BaseURI/api/scheduled-tasks/$TaskId"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Accept' = 'application/json'
        }
    }

    process {
        try {
            Write-Debug "Sending GET request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

            if ($response) {
                Write-Debug "Successfully retrieved task information"
                return $response | ConvertTo-Json -Depth 10
            }
            else {
                Write-Warning "No task information retrieved"
                return $null
            }
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to retrieve task information. Status code: $statusCode - $statusDescription"

            if ($statusCode -eq 401) {
                Write-Debug "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 404) {
                Write-Debug "Task with ID $TaskId not found."
            }

            throw $_
        }
    }

    end {
        Write-Debug "Get-ScheduledTaskInfo function completed"
    }
}