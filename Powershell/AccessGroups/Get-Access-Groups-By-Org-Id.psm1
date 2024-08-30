<#
    .SYNOPSIS
    Retrieves access groups information for an organization unit.

    .DESCRIPTION
    This function makes a GET request to the /api/org-units/{orgUnitId}/access-groups endpoint
    to retrieve access groups information for a specified organization unit.

    .INPUTS
    - BaseURI: The base URI of the API endpoint
    - AccessToken: The access token for authentication
    - OrgUnitId: The ID of the organization unit
    - PageNumber: The page number to retrieve (optional)
    - PageSize: The number of items per page (optional)
    - SortBy: The field to sort the results by (optional)
    - SortOrder: The order to sort the results (optional)

    .OUTPUTS
    Returns a JSON object containing the access groups information.

    .NOTES

    .EXAMPLE
    $result = Get-AccessGroupsForOrgID -BaseURI "https://api.example.com" -AccessToken "your_access_token" -OrgUnitId 123

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    Other extra arguments are the BaseURI of the API endpoint and the AccessToken needed for authentication.
#>
function Get-AccessGroupsForOrgID {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [string]$OrgUnitId,

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

    # Construct the full URI
    $uri = "$BaseURI/api/org-units/$OrgUnitId/access-groups"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Append query parameters to the URI if any
    if ($queryParams.Count -gt 0) {
        $queryString = New-HttpQueryString -Parameters $queryParams
        $uri += "?$queryString"
    }

    # Prepare headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Accept" = "application/json"
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

        # Return the JSON response
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP Error $statusCode : $statusDescription"

        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd()
            Write-Debug "Full Response Body: $responseBody"
        }

        # Return null or a custom error object
        return $null
    }
}
