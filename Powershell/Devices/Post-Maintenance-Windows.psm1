<#
    .SYNOPSIS
    Adds set of maintenance windows for a list of given devices.

    .DESCRIPTION
    This function adds a set of maintenance windows for specified devices using the N-able N-central API.

    .INPUTS
    - DeviceIDs: An array of device IDs to apply the maintenance windows to.
    - MaintenanceWindows: An array of maintenance window objects to be added.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the response from the API.

    .NOTES
    This function is based on the N-able N-central API specification.

    .EXAMPLE
    $deviceIDs = @(123456789, 234567890, 345678901)
    $maintenanceWindows = @(
        @{
            applicableAction = @(
                @{
                    actions = @(
                        @{
                            Key = "detect"
                            Value = $null
                        }
                    )
                    type = "Patch"
                }
            )
            cron = "0 0 0 ? 2 1,4 *"
            downtimeOnAction = $false
            duration = 60
            enabled = $true
            maxDowntime = 0
            messageSender = $null
            messageSenderEnabled = $false
            name = "Test Maintenance Window"
            preserveStateEnabled = $false
            rebootDelay = 0
            rebootMethod = "allowUserToPostpone"
            type = "action"
            userMessage = $null
            userMessageEnabled = $false
        }
    )
    $baseUri = "https://api.ncentral.com"
    $accessToken = "your_access_token_here"

    $result = Add-MaintenanceWindows -DeviceIDs $deviceIDs -MaintenanceWindows $maintenanceWindows -BaseURI $baseUri -AccessToken $accessToken

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/devices/maintenance-windows endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Add-MaintenanceWindows {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$DeviceIDs,

        [Parameter(Mandatory = $true)]
        [array]$MaintenanceWindows,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $endpoint = "$BaseURI/api/devices/maintenance-windows"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }

        # Initialize debug logging
        $DebugPreference = 'Continue'
        Write-Debug "Function Add-MaintenanceWindows started"
        Write-Debug "Endpoint: $endpoint"
    }

    process {
        try {
            # Construct the request body
            $body = @{
                deviceIDs = $DeviceIDs
                maintenanceWindows = $MaintenanceWindows
            } | ConvertTo-Json -Depth 10

            Write-Debug "Request body: $body"

            # Send the POST request
            $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $body -ErrorAction Stop

            Write-Debug "API request successful"
            return $response
        }
        catch {
            Write-Error "An error occurred while adding maintenance windows: $_"
            
            if ($_.Exception.Response) {
                $statusCode = $_.Exception.Response.StatusCode.value__
                $statusDescription = $_.Exception.Response.StatusDescription

                Write-Debug "Status Code: $statusCode"
                Write-Debug "Status Description: $statusDescription"

                # Handle specific status codes
                switch ($statusCode) {
                    400 { Write-Warning "Bad Request: The server cannot process the request due to a client error." }
                    401 { Write-Warning "Unauthorized: Authentication has failed or has not been provided." }
                    403 { Write-Warning "Forbidden: The server understood the request but refuses to authorize it." }
                    404 { Write-Warning "Not Found: The requested resource could not be found." }
                    500 { Write-Warning "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request." }
                    default { Write-Warning "An unexpected error occurred." }
                }
            }

            # Return null or a custom error object
            return $null
        }
    }

    end {
        Write-Debug "Function Add-MaintenanceWindows completed"
    }
}