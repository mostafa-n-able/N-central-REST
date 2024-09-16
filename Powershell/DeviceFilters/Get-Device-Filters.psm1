<#
    .SYNOPSIS
    Retrieves a list of device filters from N-central.

    .DESCRIPTION
    This function calls the GET /api/device-filters endpoint to retrieve a list of device filters
    from N-central for the logged-in user. It supports pagination, sorting, and filtering options.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of device filters.

    .NOTES
    This function is part of a PowerShell module for interacting with the N-central API.

    .EXAMPLE
    Get-NCentralDeviceFilters -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .EXAMPLE
    Get-NCentralDeviceFilters -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -ViewScope "OWN_AND_USED" -PageNumber 2 -PageSize 50 -SortBy "filterName" -SortOrder "DESC"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/device-filters endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-NCentralDeviceFilters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ALL", "OWN_AND_USED")]
        [string]$ViewScope = "ALL",

        [Parameter(Mandatory = $false)]
        [int]$PageNumber,

        [Parameter(Mandatory = $false)]
        [int]$PageSize,

        [Parameter(Mandatory = $false)]
        [string]$Select,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ASC", "DESC")]
        [string]$SortOrder
    )

    # Construct the endpoint URL
    $endpointUrl = "$BaseURI/api/device-filters"

    # Prepare query parameters
    $queryParams = @{}
    if ($ViewScope) { $queryParams["viewScope"] = $ViewScope }
    if ($PageNumber) { $queryParams["pageNumber"] = $PageNumber }
    if ($PageSize) { $queryParams["pageSize"] = $PageSize }
    if ($Select) { $queryParams["select"] = $Select }
    if ($SortBy) { $queryParams["sortBy"] = $SortBy }
    if ($SortOrder) { $queryParams["sortOrder"] = $SortOrder }

    # Construct query string
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

    # Initialize result variable
    $result = $null

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $endpointUrl -Headers $headers -Method Get -ErrorAction Stop

        # Process the response
        $result = $response | ConvertTo-Json -Depth 10

        Write-Debug "Successfully retrieved device filters: $result"
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "Failed to retrieve device filters. Status code: $statusCode. Description: $statusDescription"

        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Debug "Response body: $responseBody"
            $reader.Close()
        }
    }

    return $result
}