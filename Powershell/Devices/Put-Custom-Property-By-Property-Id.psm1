<#
    .SYNOPSIS
    Modifies a custom property for a specific device.

    .DESCRIPTION
    This function updates the value of a custom property for a given device using the N-able N-central API.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the result of the operation.

    .NOTES
    This function requires the N-able N-central API access token for authentication.

    .EXAMPLE
    Update-DeviceCustomProperty -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -DeviceId 123456 -PropertyId 789012 -Value "New Property Value"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/devices/{deviceId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Update-DeviceCustomProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [int]$DeviceId,

        [Parameter(Mandatory = $true)]
        [int]$PropertyId,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $ProgressPreference = 'SilentlyContinue'

        # Construct the full URI
        $Uri = "${BaseURI}/api/devices/${DeviceId}/custom-properties/${PropertyId}"

        # Prepare the headers
        $Headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }

        # Prepare the body
        $Body = @{
            value = $Value
        } | ConvertTo-Json
    }

    process {
        try {
            Write-Debug "Sending PUT request to $Uri"
            
            # Send the PUT request
            $Response = Invoke-RestMethod -Uri $Uri -Method Put -Headers $Headers -Body $Body -ErrorVariable RestError

            Write-Debug "Request successful. Processing response."
            return $Response
        }
        catch {
            $StatusCode = $_.Exception.Response.StatusCode.value__
            $StatusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $StatusCode $StatusDescription at $Uri"
            
            if ($RestError) {
                Write-Error $RestError.Message
            }

            # Attempt to parse error response
            try {
                $ErrorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
                Write-Debug "Error response: $($ErrorResponse | ConvertTo-Json -Depth 10)"
                
                if ($ErrorResponse.message) {
                    Write-Error $ErrorResponse.message
                }
            }
            catch {
                Write-Debug "Could not parse error response as JSON"
            }

            throw
        }
    }
}