<#
    .SYNOPSIS
    Retrieves a specific custom property for a device.

    .DESCRIPTION
    This function retrieves a custom property for a device using the device ID and property ID.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the custom property information.

    .NOTES
    This function requires the BaseURI and AccessToken parameters for authentication.

    .EXAMPLE
    Get-DeviceCustomProperty -DeviceId 123456 -PropertyId 789012 -BaseURI "https://api.example.com" -AccessToken "your_access_token_here"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function Get-DeviceCustomProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$DeviceId,

        [Parameter(Mandatory = $true)]
        [int]$PropertyId,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    # Construct the full URI
    $uri = "${BaseURI}/api/devices/${DeviceId}/custom-properties/${PropertyId}"

    # Set up headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Accept" = "application/json"
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop

        # Log successful request
        Write-Debug "Successfully retrieved custom property for Device ID: $DeviceId, Property ID: $PropertyId"

        # Return the response data
        return $response
    }
    catch {
        # Log the error
        Write-Error "Failed to retrieve custom property. StatusCode: $($_.Exception.Response.StatusCode.value__). Message: $($_.Exception.Message)"

        # Handle specific error codes
        switch ($_.Exception.Response.StatusCode.value__) {
            400 { Write-Error "Bad Request: Invalid device ID or property ID." }
            401 { Write-Error "Unauthorized: Authentication failed. Please check your access token." }
            403 { Write-Error "Forbidden: You don't have permission to access this resource." }
            404 { Write-Error "Not Found: The specified device or custom property was not found." }
            500 { Write-Error "Internal Server Error: An unexpected error occurred on the server." }
            default { Write-Error "An unexpected error occurred." }
        }

        # Re-throw the exception for further handling if needed
        throw
    }
}