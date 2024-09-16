<#
    .SYNOPSIS
    Retrieves job statuses for a specific organization unit.

    .DESCRIPTION
    This function fetches a list of job statuses for the given organization unit using the GET /api/org-units/{orgUnitId}/job-statuses endpoint.

    .PARAMETER OrgUnitId
    The ID of the organization unit for which to retrieve job statuses.

    .PARAMETER BaseURI
    The base URI of the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of job statuses.

    .NOTES
    This function is based on the PREVIEW endpoint and may be subject to changes.

    .EXAMPLE
    $jobStatuses = Get-OrgUnitJobStatuses -OrgUnitId 12345 -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/job-statuses endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrgUnitJobStatuses {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $uri = "${BaseURI}/api/org-units/${OrgUnitId}/job-statuses"

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
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            # Return the response as a JSON object
            return $response | ConvertTo-Json -Depth 10

        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Error accessing the API. Status code: $statusCode - $statusDescription"

            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $reader.BaseStream.Position = 0
                $reader.DiscardBufferedData()
                $responseBody = $reader.ReadToEnd()
                Write-Debug "Full response body: $responseBody"
            }

            throw $_
        }
    }
}