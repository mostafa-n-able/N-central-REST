<#
    .SYNOPSIS
    Retrieves a list of all organization units.

    .DESCRIPTION
    This function calls the GET /api/org-units endpoint to retrieve a list of all organization units.
    It supports pagination, sorting, and custom field selection.

    .PARAMETER BaseURI
    The base URI for the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER PageNumber
    The page number to retrieve. Starts at 1. If not provided, defaults to the first page.

    .PARAMETER PageSize
    The number of items to retrieve per page. Set to -1 to retrieve all items without pagination (if enabled).

    .PARAMETER Select
    The select expression to filter the fields in the response.

    .PARAMETER SortBy
    The name of a field to sort the result by.

    .PARAMETER SortOrder
    The order in which to sort the results. Supports ASC/ASCENDING/NATURAL and DESC/DESCENDING/REVERSE.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of organization units.

    .NOTES
    This function requires the New-HttpQueryString function to be available in the script's context.

    .EXAMPLE
    $result = Get-OrganizationUnits -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrganizationUnits {
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
        [string]$Select,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ASC", "ASCENDING", "NATURAL", "DESC", "DESCENDING", "REVERSE")]
        [string]$SortOrder
    )

    # Construct the full URI
    $uri = "$BaseURI/api/org-units"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Construct query string
    $queryString = New-HttpQueryString -Parameters $queryParams

    # Append query string to URI if not empty
    if ($queryString) {
        $uri += "?$queryString"
    }

    # Prepare headers
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Accept' = 'application/json'
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP $statusCode $statusDescription at $uri"
        
        # Additional error handling based on status codes
        switch ($statusCode) {
            400 { Write-Debug "Bad Request: The server cannot process the request due to a client error." }
            401 { Write-Debug "Unauthorized: Authentication has failed or has not been provided." }
            403 { Write-Debug "Forbidden: The server understood the request but refuses to authorize it." }
            404 { Write-Debug "Not Found: The requested resource could not be found." }
            500 { Write-Debug "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
            default { Write-Debug "An unexpected error occurred." }
        }

        # Optionally, you can re-throw the exception if you want calling code to handle it
        # throw
    }
}