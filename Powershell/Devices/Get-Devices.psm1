<#
    .SYNOPSIS
    Retrieves a list of devices from N-central.

    .DESCRIPTION
    This function retrieves a list of devices from N-central using the GET /api/devices endpoint.
    It supports pagination, sorting, and filtering.

    .INPUTS
    None

    .OUTPUTS
    System.Object
    Returns a JSON object containing the list of devices and pagination information.

    .NOTES
    This function requires the BaseURI of the API endpoint and a valid AccessToken for authentication.

    .EXAMPLE
    $devices = Get-Devices -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-Devices {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [int]$FilterId,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false)]
        [string]$Select,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder = "ASC"
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }
        $endpoint = "$BaseURI/api/devices"
    }

    process {
        try {
            Write-Debug "Preparing query parameters"
            $queryParams = @{}
            if ($FilterId) { $queryParams['filterId'] = $FilterId }
            if ($PageNumber -ne 1) { $queryParams['pageNumber'] = $PageNumber }
            if ($PageSize -ne 50) { $queryParams['pageSize'] = $PageSize }
            if ($Select) { $queryParams['select'] = $Select }
            if ($SortBy) { $queryParams['sortBy'] = $SortBy }
            if ($SortOrder -ne "ASC") { $queryParams['sortOrder'] = $SortOrder }

            $queryString = New-HttpQueryString -Parameters $queryParams

            $uri = if ($queryString) { "$endpoint`?$queryString" } else { $endpoint }

            Write-Debug "Sending GET request to $uri"
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

            Write-Debug "Request successful. Processing response."
            return $response | ConvertTo-Json -Depth 10
        }
        catch {
            Write-Error "An error occurred while retrieving devices: $_"
            if ($_.Exception.Response) {
                $statusCode = [int]$_.Exception.Response.StatusCode
                $statusDescription = $_.Exception.Response.StatusDescription
                Write-Debug "HTTP Status Code: $statusCode - $statusDescription"

                if ($statusCode -eq 401) {
                    Write-Warning "Authentication failed. Please check your AccessToken."
                }
                elseif ($statusCode -eq 403) {
                    Write-Warning "Access forbidden. You may not have the necessary permissions."
                }
                elseif ($statusCode -eq 404) {
                    Write-Warning "The requested resource was not found."
                }
            }
        }
    }

    end {
        Write-Debug "Function Get-Devices completed."
    }
}