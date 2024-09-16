<#
    .SYNOPSIS
    Retrieves a list of all service organizations.

    .DESCRIPTION
    This function calls the GET /api/service-orgs endpoint to retrieve a list of all service organizations.
    It supports pagination, sorting, and custom field selection.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the list of service organizations and pagination information.

    .NOTES
    This function requires the BaseURI of the API endpoint and a valid AccessToken for authentication.

    .EXAMPLE
    $result = Get-ServiceOrganizations -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/service-orgs endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ServiceOrganizations {
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

    $endpoint = "$BaseURI/api/service-orgs"

    # Construct query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    $queryString = New-HttpQueryString -Parameters $queryParams

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
            throw "Authentication failed. Please check your AccessToken."
        }
        elseif ($statusCode -eq 403) {
            throw "Access forbidden. You may not have the necessary permissions."
        }
        elseif ($statusCode -eq 404) {
            throw "Resource not found. Please check the BaseURI."
        }
        else {
            throw "An error occurred while retrieving service organizations: $_"
        }
    }
}