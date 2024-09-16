<#
    .SYNOPSIS
    Retrieves a list of all organization units under a specific parent organization unit.

    .DESCRIPTION
    This function calls the GET /api/org-units/{orgUnitId}/children endpoint to retrieve a list of child organization units for a given parent organization unit ID.

    .INPUTS
    - OrgUnitId: The ID of the parent organization unit.
    - PageNumber: The page number to retrieve (optional).
    - PageSize: The number of items per page (optional).
    - Select: The select expression for filtering results (optional).
    - SortBy: The field to sort the results by (optional).
    - SortOrder: The order to sort the results (optional).
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of child organization units.

    .NOTES
    This function is based on the PREVIEW version of the API endpoint.

    .EXAMPLE
    $result = Get-OrganizationUnitChildren -OrgUnitId 123 -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/children endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrganizationUnitChildren {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

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
        [string]$SortOrder = "ASC",

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "$BaseURI/api/org-units/$OrgUnitId/children"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Accept" = "application/json"
        }

        $queryParams = @{}
        if ($PageNumber) { $queryParams["pageNumber"] = $PageNumber }
        if ($PageSize) { $queryParams["pageSize"] = $PageSize }
        if ($Select) { $queryParams["select"] = $Select }
        if ($SortBy) { $queryParams["sortBy"] = $SortBy }
        if ($SortOrder) { $queryParams["sortOrder"] = $SortOrder }
    }

    process {
        try {
            $queryString = New-HttpQueryString -Parameters $queryParams

            $uri = if ($queryString) {
                "$endpoint`?$queryString"
            } else {
                $endpoint
            }

            $invokeParams = @{
                Uri = $uri
                Headers = $headers
                Method = "GET"
                ContentType = "application/json"
                ErrorAction = "Stop"
            }

            Write-Debug "Sending request to $uri"
            $response = Invoke-RestMethod @invokeParams

            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription at $uri"
            Write-Debug $_.Exception.Message
            Write-Debug $_.ErrorDetails.Message

            if ($statusCode -eq 401) {
                throw "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                throw "Authorization failed. You don't have permission to access this resource."
            }
            elseif ($statusCode -eq 404) {
                throw "The specified organization unit was not found."
            }
            else {
                throw "An error occurred while retrieving organization unit children: $_"
            }
        }
    }
}