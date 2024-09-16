<#
    .SYNOPSIS
    Retrieves a list of sites for a specific customer.

    .DESCRIPTION
    This function sends a GET request to the '/api/customers/{customerId}/sites' endpoint
    to retrieve a list of sites associated with the specified customer ID.

    .INPUTS
    - CustomerId: The ID of the customer for which to retrieve sites.
    - PageNumber: The page number to retrieve (optional).
    - PageSize: The number of items per page (optional).
    - Select: The select expression for filtering results (optional).
    - SortBy: The field to sort the results by (optional).
    - SortOrder: The order to sort the results (optional).
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of sites for the specified customer.

    .NOTES
    This function is based on the N-able N-central API v1.0.

    .EXAMPLE
    $sites = Get-CustomerSites -CustomerId 12345 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers/{customerId}/sites endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-CustomerSites {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$CustomerId,

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
        [string]$SortOrder,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    # Construct the API endpoint URL
    $endpoint = "$BaseURI/api/customers/$CustomerId/sites"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Construct query string
    $queryString = New-HttpQueryString -Parameters $queryParams

    # Append query string to endpoint if not empty
    if ($queryString) {
        $endpoint += "?$queryString"
    }

    # Prepare headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Accept" = "application/json"
    }

    try {
        # Send GET request to the API
        $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ErrorAction Stop

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP Status Code: $statusCode - $statusDescription"

        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Debug "Response content: $responseBody"
            $reader.Close()
        }

        Write-Error "An error occurred while retrieving customer sites: $_"
    }
}