<#
    .SYNOPSIS
    Retrieves a list of all customers from the N-able API.

    .DESCRIPTION
    This function sends a GET request to the /api/customers endpoint of the N-able API
    and returns the list of customers as a JSON object.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the list of customers.

    .NOTES
    This function requires the BaseURI of the API endpoint and a valid AccessToken.

    .EXAMPLE
    $customers = Get-NAbleCustomers -BaseURI "https://api.n-able.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-NAbleCustomers {
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
        [string]$SortOrder = "ASC"
    )

    $endpoint = "$BaseURI/api/customers"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Build query string
    $queryString = New-HttpQueryString -Parameters $queryParams

    # Append query string to endpoint if not empty
    if ($queryString) {
        $endpoint += "?$queryString"
    }

    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Accept" = "application/json"
    }

    try {
        Write-Debug "Sending GET request to $endpoint"
        $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ErrorAction Stop

        Write-Debug "Request successful. Processing response."
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP $statusCode : $statusDescription"
        Write-Debug "Error details: $_"

        if ($statusCode -eq 401) {
            Write-Warning "Authentication failed. Please check your AccessToken."
        }
        elseif ($statusCode -eq 403) {
            Write-Warning "Access forbidden. You may not have the necessary permissions."
        }
        elseif ($statusCode -eq 404) {
            Write-Warning "Resource not found. Please check the BaseURI."
        }

        return $null
    }
}