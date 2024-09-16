<#
    .SYNOPSIS
    Updates the asset lifecycle information for a specific device.

    .DESCRIPTION
    This function updates the asset lifecycle information for a device with the specified device ID using the PUT /api/devices/{deviceId}/assets/lifecycle-info endpoint.

    .INPUTS
    - DeviceId: The ID of the device to update.
    - AssetLifecycleInfo: An object containing the asset lifecycle information to update.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    The function returns a JSON object containing the updated asset lifecycle information.

    .NOTES
    This function requires the New-HttpQueryString function to be available.

    .EXAMPLE
    $assetInfo = @{
        assetTag = "ASSET123"
        cost = 1000.00
        description = "New laptop"
        expectedReplacementDate = "2025-12-31"
        leaseExpiryDate = "2024-12-31"
        location = "Main Office"
        purchaseDate = "2023-01-01"
        warrantyExpiryDate = "2026-12-31"
    }
    $result = Update-DeviceAssetLifecycleInfo -DeviceId 123456 -AssetLifecycleInfo $assetInfo -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/devices/{deviceId}/assets/lifecycle-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Update-DeviceAssetLifecycleInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]$AssetLifecycleInfo,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/devices/$DeviceId/assets/lifecycle-info"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            # Validate required fields
            $requiredFields = @('assetTag', 'cost', 'description', 'expectedReplacementDate', 'leaseExpiryDate', 'location', 'purchaseDate', 'warrantyExpiryDate')
            foreach ($field in $requiredFields) {
                if (-not $AssetLifecycleInfo.$field) {
                    throw "Missing required field: $field"
                }
            }

            # Validate date fields
            $dateFields = @('expectedReplacementDate', 'leaseExpiryDate', 'purchaseDate', 'warrantyExpiryDate')
            foreach ($field in $dateFields) {
                if ($AssetLifecycleInfo.$field -and -not ($AssetLifecycleInfo.$field -match '^\d{4}-\d{2}-\d{2}(?: \d{2}:\d{2}:\d{2}(?:\.\d{1,9})?)?$')) {
                    throw "Invalid date format for $field. Expected format: YYYY-MM-DD[ HH:MM:SS[.fffffffff]]"
                }
            }

            # Convert AssetLifecycleInfo to JSON
            $body = $AssetLifecycleInfo | ConvertTo-Json -Depth 10

            # Make the API request
            $response = Invoke-RestMethod -Uri $endpoint -Method Put -Headers $headers -Body $body -ErrorVariable responseError

            # Return the response
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to update asset lifecycle info. Status code: $statusCode - $statusDescription"
            
            if ($responseError) {
                Write-Debug "Error details: $($responseError.Message)"
            }

            throw $_
        }
    }
}