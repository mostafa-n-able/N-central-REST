<#
    .SYNOPSIS
    Retrieves a list of customers for a specific service organization.

    .DESCRIPTION
    This function makes a GET request to the '/api/service-orgs/{soId}/customers' endpoint to retrieve a list of customers associated with a given service organization ID.

    .PARAMETER BaseURI
    The base URI of the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER SoId
    The ID of the service organization for which to retrieve customers.

    .PARAMETER PageNumber
    The page number to retrieve. Starts at 1. If not provided, defaults to the first page.

    .PARAMETER PageSize
    The number of items to retrieve per page. Set to -1 to retrieve all items without pagination (if enabled).

    .PARAMETER Select
    The select expression for filtering the response.

    .PARAMETER SortBy
    The name of a field to sort the result by.

    .PARAMETER SortOrder
    The order in which the results will be sorted. Default is ASC.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    The function returns a JSON object containing the list of customers for the specified service organization.

    .NOTES
    This function requires the 'New-HttpQueryString' function to be available for creating the query parameter string.

    .EXAMPLE
    $customers = Get-ServiceOrgCustomers -BaseURI "https://api.example.com" -AccessToken "your_access_token" -SoId 123 -PageSize 50 -SortBy "customerName"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/service-orgs/{soId}/customers endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ServiceOrgCustomers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [int]$SoId,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber,

        [Parameter(Mandatory = $false)]
        [int]$PageSize,

        [Parameter(Mandatory = $false)]
        [string]$Select,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder = "ASC"
    )

    # Construct the endpoint URL
    $endpointUrl = "${BaseURI}/api/service-orgs/${SoId}/customers"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Create query string
    $queryString = New-HttpQueryString -Parameters $queryParams

    # Append query string to endpoint URL if not empty
    if ($queryString) {
        $endpointUrl += "?$queryString"
    }

    # Prepare headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Accept" = "application/json"
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $endpointUrl -Headers $headers -Method Get -ErrorAction Stop

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP Error ${statusCode}: ${statusDescription}"

        # Additional error handling based on status codes
        switch ($statusCode) {
            400 { Write-Debug "Bad Request: The server cannot process the request due to a client error." }
            401 { Write-Debug "Unauthorized: Authentication has failed or has not been provided." }
            403 { Write-Debug "Forbidden: The server understood the request but refuses to authorize it." }
            404 { Write-Debug "Not Found: The requested resource could not be found." }
            500 { Write-Debug "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
            default { Write-Debug "An unexpected error occurred." }
        }

        # Optionally, you can return a custom error object
        return @{
            Error = $true
            StatusCode = $statusCode
            Message = $statusDescription
        } | ConvertTo-Json
    }
}