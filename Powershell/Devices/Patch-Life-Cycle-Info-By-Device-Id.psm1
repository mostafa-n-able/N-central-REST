<#
    .SYNOPSIS
    Updates the Asset Lifecycle Information for a device.

    .DESCRIPTION
    This function sends a PATCH request to update the Asset Lifecycle Information for a specific device using the N-able API.

    .INPUTS
    - DeviceId: The ID of the device to update.
    - AssetLifecycleInfo: A hashtable containing the Asset Lifecycle Information to update.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for API authentication.

    .OUTPUTS
    The function returns a JSON object containing the updated Asset Lifecycle Information.

    .NOTES
    This function requires the 'New-HttpQueryString' function to be available.

    .EXAMPLE
    $assetInfo = @{
        assetTag = "NEW-TAG-001"
        cost = 1000.00
        description = "Updated asset description"
        expectedReplacementDate = "2025-12-31"
    }
    Update-DeviceAssetLifecycleInfo -DeviceId 123456 -AssetLifecycleInfo $assetInfo -BaseURI "https://api.n-able.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PATCH /api/devices/{deviceId}/assets/lifecycle-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Update-DeviceAssetLifecycleInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,

        [Parameter(Mandatory = $true)]
        [hashtable]$AssetLifecycleInfo,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "$BaseURI/api/devices/$DeviceId/assets/lifecycle-info"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }
    }

    process {
        try {
            Write-Debug "Preparing to send PATCH request to $endpoint"

            # Validate and prepare the request body
            $validProperties = @('assetTag', 'cost', 'description', 'expectedReplacementDate', 'leaseExpiryDate', 'location', 'purchaseDate', 'warrantyExpiryDate')
            $requestBody = @{}
            foreach ($key in $AssetLifecycleInfo.Keys) {
                if ($validProperties -contains $key) {
                    $requestBody[$key] = $AssetLifecycleInfo[$key]
                }
                else {
                    Write-Warning "Invalid property '$key' will be ignored."
                }
            }

            # Convert request body to JSON
            $jsonBody = $requestBody | ConvertTo-Json

            Write-Debug "Request Body: $jsonBody"

            # Send the PATCH request
            $response = Invoke-RestMethod -Uri $endpoint -Method Patch -Headers $headers -Body $jsonBody -ErrorAction Stop

            Write-Debug "Response received successfully"
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to update Asset Lifecycle Information. Status code: $statusCode - $statusDescription"
            Write-Debug "Error details: $_"

            if ($statusCode -eq 401) {
                throw "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 404) {
                throw "Device with ID $DeviceId not found."
            }
            else {
                throw "An error occurred while updating Asset Lifecycle Information: $_"
            }
        }
    }

    end {
    }
}
