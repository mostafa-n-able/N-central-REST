<#
    .SYNOPSIS
    Retrieves user roles for a given organization unit.

    .DESCRIPTION
    This function makes a GET request to the /api/org-units/{orgUnitId}/user-roles endpoint
    to retrieve a list of user roles for the specified organization unit.

    .INPUTS
    - OrgUnitId: The ID of the organization unit (Required)
    - PageNumber: The page number to retrieve (Optional)
    - PageSize: The number of items to retrieve per page (Optional)
    - SortBy: The field to sort the results by (Optional)
    - SortOrder: The order to sort the results (Optional)
    - BaseURI: The base URI of the API endpoint (Required)
    - AccessToken: The access token for authentication (Required)

    .OUTPUTS
    Returns a JSON object containing the list of user roles and pagination information.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: Yes

    .NOTES
    This function requires PowerShell 5.1 or later.
    Make sure to handle the AccessToken securely.

    .EXAMPLE
    $roles = Get-UserRoles -OrgUnitId 123 -BaseURI "https://api.example.com" -AccessToken "your_access_token"
#>
function Get-UserRoles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory=$false)]
        [int]$PageNumber,

        [Parameter(Mandatory=$false)]
        [int]$PageSize,

        [Parameter(Mandatory=$false)]
        [string]$SortBy,

        [Parameter(Mandatory=$false)]
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder,

        [Parameter(Mandatory=$true)]
        [string]$BaseURI,

        [Parameter(Mandatory=$true)]
        [string]$AccessToken
    )

    # Construct the API endpoint URL
    $endpoint = "$BaseURI/api/org-units/$OrgUnitId/user-roles"

    # Prepare query parameters
    $queryParams = @{}
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    # Construct query string
    $queryString = $queryParams.Keys | ForEach-Object { "$_=$($queryParams[$_])" }
    if ($queryString) {
        $endpoint += "?" + ($queryString -join "&")
    }

    # Prepare headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Accept" = "application/json"
    }

    # Initialize result variable
    $result = $null

    try {
        Write-Debug "Sending GET request to $endpoint"
        $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get -ErrorAction Stop

        # Check if the response is valid
        if ($response.PSObject.Properties.Name -contains 'data') {
            $result = $response | ConvertTo-Json -Depth 10
            Write-Debug "Successfully retrieved user roles"
        } else {
            throw "Invalid response format"
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP $statusCode : $statusDescription"
        Write-Debug "Error details: $_"

        if ($statusCode -eq 401) {
            Write-Warning "Authentication failed. Please check your AccessToken."
        } elseif ($statusCode -eq 403) {
            Write-Warning "Access forbidden. You may not have the necessary permissions."
        } elseif ($statusCode -eq 404) {
            Write-Warning "Organization unit not found. Please check the OrgUnitId."
        }
    }

    return $result
}