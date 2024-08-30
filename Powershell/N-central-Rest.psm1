Import-Module ./Utilities.psm1

<#
    .SYNOPSIS
    Authenticates with the N-central API and retrieves access and refresh tokens.

    .DESCRIPTION
    This function takes a JWT token and base URI as input, authenticates with the N-central API,
    and returns the access_token and refresh_token in a dictionary.

    .INPUTS
    - Token: A string containing the JWT token for authentication.
    - BaseUri: A string containing the base URI for the API.

    .OUTPUTS
    A hashtable containing the access_token and refresh_token.

    .NOTES
    This function requires PowerShell 5.1 or later.
    Error handling and logging are implemented for robustness.

    .EXAMPLE
    $result = Get-NcentralAuthTokens -Token "your_jwt_token" -BaseUri "api.example.com"
    $accessToken = $result.access_token
    $refreshToken = $result.refresh_token
#>
function Get-NcentralAuthTokens {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$BaseUri
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $VerbosePreference = 'Continue'

        # Construct the full URI for the authentication endpoint
        $authUri = "$BaseUri/api/auth/authenticate"
        Write-Verbose "Authentication URI: $authUri"
    }

    process {
        try {
            Write-Verbose "Attempting to authenticate with the N-central API..."

            # Prepare the headers for the API request
            $headers = @{
                'Authorization' = "Bearer $Token"
                'Content-Type' = 'application/json'
            }

            # Make the API request
            $response = Invoke-RestMethod -Uri $authUri -Method Post -Headers $headers -ErrorAction Stop

            Write-Verbose "Successfully authenticated with the N-central API."

            # Extract the access and refresh tokens from the response
            $accessToken = $response.tokens.access.token
            $refreshToken = $response.tokens.refresh.token

            # Check if both tokens were received
            if (-not $accessToken -or -not $refreshToken) {
                throw "Failed to retrieve both access and refresh tokens from the API response."
            }

            # Create and return the result hashtable
            $result = @{
                access_token = $accessToken
                refresh_token = $refreshToken
            }

            return $result
        }
        catch {
            Write-Error "An error occurred while authenticating: $_"
            throw
        }
    }

    end {
        Write-Verbose "Authentication process completed."
    }
}

<#
    .SYNOPSIS
    Retrieves a list of devices from the N-central API.

    .DESCRIPTION
    This function sends a GET request to the /api/devices endpoint of the N-central API
    and returns the list of devices as a JSON object. It supports pagination and sorting.

    .INPUTS

    .OUTPUTS
    System.Object. Returns a JSON object containing the list of devices.

    .NOTES

    .EXAMPLE
    $devices = Get-NCentralDevices -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -PageNumber 1 -PageSize 50 -SortBy "deviceId" -SortOrder "asc"
#>
function Get-NCentralDevices {
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
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "natural", "desc", "descending", "reverse")]
        [string]$SortOrder = "ASC"
    )

    $ErrorActionPreference = 'Stop'
    #$DebugPreference = 'Continue'

    Write-Debug "Starting Get-NCentralDevices function"

    # Construct the API endpoint URL
    $apiEndpoint = "$BaseURI/api/devices"
    Write-Debug "API Endpoint: $apiEndpoint"

    # Construct query parameters
    $queryParams = @{}
    if ($FilterId) { $queryParams['filterId'] = $FilterId }
    if ($PageNumber) { $queryParams['pageNumber'] = $PageNumber }
    if ($PageSize) { $queryParams['pageSize'] = $PageSize }
    if ($SortBy) { $queryParams['sortBy'] = $SortBy }
    if ($SortOrder) { $queryParams['sortOrder'] = $SortOrder }

    $queryString = New-HttpQueryString -Parameters $queryParams
    $fullUrl = "$apiEndpoint$queryString"
    Write-Debug "Full URL: $fullUrl"

    # Set up headers
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Accept' = 'application/json'
    }

    try {
        Write-Debug "Sending GET request to N-central API"
        $response = Invoke-RestMethod -Uri $fullUrl -Headers $headers -Method Get -ErrorAction Stop

        Write-Debug "Request successful. Processing response."
        return $response | ConvertTo-Json -Depth 10

    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "Error occurred while fetching devices: $statusCode $statusDescription"
        Write-Debug "Error details: $_"

        if ($statusCode -eq 401) {
            Write-Warning "Authentication failed. Please check your access token."
        }
        elseif ($statusCode -eq 403) {
            Write-Warning "Access forbidden. You may not have the necessary permissions."
        }
        elseif ($statusCode -eq 404) {
            Write-Warning "Resource not found. Please check the API endpoint URL."
        }
        elseif ($statusCode -ge 500) {
            Write-Warning "Server error occurred. Please try again later or contact support."
        }

        return $null
    }
}

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
