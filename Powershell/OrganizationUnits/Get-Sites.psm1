<#
    .SYNOPSIS
    Retrieves a list of all sites from the N-able N-central API.

    .DESCRIPTION
    This function makes a GET request to the /api/sites endpoint of the N-able N-central API
    and returns the list of all sites as a JSON object. It supports pagination and sorting.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the list of sites and pagination information.

    .NOTES
    This function requires the BaseURI of the API endpoint and a valid AccessToken for authentication.

    .EXAMPLE
    $sites = Get-Sites -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/sites endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-Sites {
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
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder
    )

    # Construct the API endpoint URL
    $apiEndpoint = "$BaseURI/api/sites"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Construct query string
    $queryString = New-HttpQueryString -Parameters $queryParams

    # Append query string to API endpoint if not empty
    if ($queryString) {
        $apiEndpoint += "?$queryString"
    }

    # Prepare headers
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Accept' = 'application/json'
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $apiEndpoint -Headers $headers -Method Get -ErrorAction Stop

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP $statusCode $statusDescription : $($_.Exception.Message)"

        # Additional error handling based on status codes
        switch ($statusCode) {
            400 { Write-Debug "Bad Request: The server cannot process the request due to a client error." }
            401 { Write-Debug "Unauthorized: Authentication has failed or has not been provided." }
            403 { Write-Debug "Forbidden: The server understood the request but refuses to authorize it." }
            404 { Write-Debug "Not Found: The requested resource could not be found." }
            500 { Write-Debug "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
            default { Write-Debug "An unexpected error occurred." }
        }

        return $null
    }
}