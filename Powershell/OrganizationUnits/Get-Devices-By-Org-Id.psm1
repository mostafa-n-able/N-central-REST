<#
    .SYNOPSIS
    Retrieves a list of devices for a specific organization unit.

    .DESCRIPTION
    This function uses the GET /api/org-units/{orgUnitId}/devices endpoint to fetch a list of devices
    associated with a given organization unit ID. It supports pagination, filtering, and sorting options.

    .PARAMETER BaseURI
    The base URI of the API endpoint.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER OrgUnitId
    The ID of the organization unit for which to retrieve devices.

    .PARAMETER FilterId
    Optional. The ID of the filter to apply to the device list.

    .PARAMETER PageNumber
    Optional. The page number to retrieve. Defaults to 1 if not specified.

    .PARAMETER PageSize
    Optional. The number of items to retrieve per page. Use -1 for maximum size.

    .PARAMETER SortBy
    Optional. The field to sort the results by.

    .PARAMETER SortOrder
    Optional. The order to sort the results (ASC or DESC). Defaults to ASC.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of devices and pagination information.

    .NOTES
    This function is part of a module for interacting with the N-able API.

    .EXAMPLE
    Get-OrgUnitDevices -BaseURI "https://api.example.com" -AccessToken "your_access_token" -OrgUnitId 12345

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/devices endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-OrgUnitDevices {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [string]$OrgUnitId,

        [Parameter(Mandatory = $false)]
        [int]$FilterId,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ASC", "DESC")]
        [string]$SortOrder = "ASC"
    )

    begin {
        $endpoint = "$BaseURI/api/org-units/$OrgUnitId/devices"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }

        # Initialize query parameters
        $queryParams = @{}
        if ($FilterId) { $queryParams["filterId"] = $FilterId }
        if ($PageNumber -gt 0) { $queryParams["pageNumber"] = $PageNumber }
        if ($PageSize -ne 50) { $queryParams["pageSize"] = $PageSize }
        if ($SortBy) { $queryParams["sortBy"] = $SortBy }
        if ($SortOrder -ne "ASC") { $queryParams["sortOrder"] = $SortOrder }

        # Create query string
        $queryString = New-HttpQueryString -Parameters $queryParams
    }

    process {
        try {
            $uri = "$endpoint$queryString"
            Write-Debug "Sending GET request to: $uri"

            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

            Write-Debug "Response received successfully"
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode : $statusDescription"
            Write-Debug "Error details: $_"

            if ($statusCode -eq 401) {
                throw "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 403) {
                throw "Access forbidden. You may not have the necessary permissions."
            }
            elseif ($statusCode -eq 404) {
                throw "Organization unit not found. Please check the OrgUnitId."
            }
            else {
                throw "An error occurred while fetching devices: $_"
            }
        }
    }

    end {
        # Nothing to clean up
    }
}