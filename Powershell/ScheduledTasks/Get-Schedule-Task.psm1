<#
    .SYNOPSIS
    Retrieves a list of scheduled tasks.

    .DESCRIPTION
    This function retrieves a list of scheduled tasks from the N-central API. It supports pagination and sorting.

    .PARAMETER BaseURI
    The base URI of the N-central API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER PageNumber
    The page number to retrieve. Starts at 1. If not provided, defaults to the first page.

    .PARAMETER PageSize
    The number of items to retrieve per page. Set to -1 to retrieve all items without pagination (if enabled).

    .PARAMETER SortBy
    The name of a field to sort the result by.

    .PARAMETER SortOrder
    The order in which the result will follow. Case insensitive and defaults to ASC.
    Valid values: asc, ascending, natural, desc, descending, reverse

    .OUTPUTS
    Returns a JSON object containing the list of scheduled tasks and pagination information.

    .NOTES
    This function requires the New-HttpQueryString function to create the query parameter string.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: No

    .EXAMPLE
    $tasks = Get-ScheduledTasks -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -PageSize 50 -SortBy "name" -SortOrder "asc"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    Other extra arguments are the BaseURI of the API endpoint and the AccessToken needed for authentication.
#>
function Get-ScheduledTasks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber,

        [Parameter(Mandatory = $false)]
        [int]$PageSize,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder
    )

    $ErrorActionPreference = 'Stop'

    try {
        $endpoint = "$BaseURI/api/scheduled-tasks"

        # Prepare query parameters
        $queryParams = @{}
        if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
        if ($PageSize) { $queryParams['pageSize'] = $PageSize }
        if ($SortBy) { $queryParams['sortBy'] = $SortBy }
        if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

        $queryString = New-HttpQueryString -Parameters $queryParams

        if ($queryString) {
            $endpoint += "?$queryString"
        }

        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }

        Write-Debug "Sending GET request to: $endpoint"

        $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get

        Write-Debug "Response received successfully"

        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        Write-Error "An error occurred while retrieving scheduled tasks: $_"

        if ($_.Exception.Response) {
            $statusCode = [int]$_.Exception.Response.StatusCode
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Debug "HTTP Status Code: $statusCode"
            Write-Debug "Status Description: $statusDescription"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                Write-Warning "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "The requested resource was not found."
            }
        }

        throw
    }
}