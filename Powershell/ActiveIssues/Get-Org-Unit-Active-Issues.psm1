<#
    .SYNOPSIS
    Retrieves a list of active issues for a given organization unit.

    .DESCRIPTION
    This function retrieves a list of active issues for a specified organization unit using the N-central API. It supports pagination and sorting of results.

    .INPUTS

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of active issues.

    .NOTES

    .EXAMPLE
    $response = Get-ActiveIssues -OrgUnitId 123 -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/active-issues endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-ActiveIssues {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber,

        [Parameter(Mandatory = $false)]
        [int]$PageSize,

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

    begin {
        $endpoint = "/api/org-units/$OrgUnitId/active-issues"
        $uri = $BaseURI.TrimEnd('/') + $endpoint

        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }

        $queryParams = @{}
        if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
        if ($PageSize) { $queryParams['pageSize'] = $PageSize }
        if ($SortBy) { $queryParams['sortBy'] = $SortBy }
        if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }
    }

    process {
        try {
            $queryString = New-HttpQueryString -Parameters $queryParams

            if ($queryString) {
                $uri += "?$queryString"
            }

            Write-Debug "Sending GET request to: $uri"

            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

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
                Write-Warning "Access forbidden. Please check your permissions."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Organization unit not found. Please check the OrgUnitId."
            }

            throw $_
        }
    }
}
