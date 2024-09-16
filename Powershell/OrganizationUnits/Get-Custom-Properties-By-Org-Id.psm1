<#
    .SYNOPSIS
    Retrieves custom properties for a specific organization unit.

    .DESCRIPTION
    This function retrieves the list of custom properties for a given organization unit ID using the N-able N-central API.

    .INPUTS
    - OrgUnitId: The ID of the organization unit.
    - PageNumber: The page number to retrieve (optional).
    - PageSize: The number of items per page (optional).
    - Select: The select expression for filtering results (optional).
    - SortBy: The field to sort the results by (optional).
    - SortOrder: The order to sort the results (optional).
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of custom properties for the specified organization unit.

    .NOTES
    This function requires the N-able N-central API access token for authentication.

    .EXAMPLE
    $properties = Get-OrgUnitCustomProperties -OrgUnitId 123 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/custom-properties endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrgUnitCustomProperties {
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
        [string]$SortOrder,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    # Construct the API endpoint URL
    $endpoint = "$BaseURI/api/org-units/$OrgUnitId/custom-properties"

    # Prepare the query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($Select) { $queryParams['select'] = $Select }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Construct the query string
    $queryString = New-HttpQueryString -Parameters $queryParams

    # Append the query string to the endpoint if it's not empty
    if ($queryString) {
        $endpoint += "?$queryString"
    }

    # Set up the headers for the API request
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ErrorAction Stop

        # Return the response as a JSON object
        return $response | ConvertTo-Json -Depth 10
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "API request failed with status code $statusCode: $statusDescription"
        
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Debug "Response body: $responseBody"
            $reader.Close()
        }
        
        throw $_
    }
}