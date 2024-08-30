<#
    .SYNOPSIS
    Creates a new device type access group.

    .DESCRIPTION
    This function creates a new device type access group for a specific organization unit using the N-central API.

    .INPUTS
    - OrgUnitId: The ID of the organization unit where the access group will be created.
    - GroupName: The name of the access group.
    - GroupDescription: The description of the access group.
    - DeviceIds: An array of device IDs to attach to the access group.
    - UserIds: An array of user IDs to be associated with the access group.
    - BaseURI: The base URI for the API endpoint.
    - AccessToken: The access token for API authentication.

    .OUTPUTS
    The function returns a JSON object containing the response from the API.

    .NOTES

    .EXAMPLE
    $result = New-DeviceAccessGroup -OrgUnitId 123 -GroupName "New Access Group" -GroupDescription "Description" -DeviceIds @(1001, 1002) -UserIds @(5001, 5002) -BaseURI "https://api.example.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST api/org-units/{orgUnitId}/device-access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function New-DeviceAccessGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$OrgUnitId,

        [Parameter(Mandatory = $true)]
        [string]$GroupName,

        [Parameter(Mandatory = $true)]
        [string]$GroupDescription,

        [Parameter(Mandatory = $false)]
        [int[]]$DeviceIds,

        [Parameter(Mandatory = $false)]
        [int[]]$UserIds,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/org-units/$OrgUnitId/device-access-groups"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            # Construct the request body
            $body = @{
                groupName = $GroupName
                groupDescription = $GroupDescription
            }

            if ($DeviceIds) {
                $body['deviceIds'] = $DeviceIds
            }

            if ($UserIds) {
                $body['userIds'] = $UserIds
            }

            $jsonBody = $body | ConvertTo-Json

            # Log the request details
            Write-Debug "Sending POST request to $endpoint"
            Write-Debug "Request Body: $jsonBody"

            # Send the request
            $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $jsonBody

            # Log the response
            Write-Debug "Response received: $($response | ConvertTo-Json -Depth 5)"

            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "API request failed with status code $statusCode - $statusDescription"
            Write-Debug "Error details: $($_.Exception.Message)"

            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $responseBody = $reader.ReadToEnd()
                Write-Debug "Response body: $responseBody"
                $reader.Close()
            }

            throw
        }
    }
}
