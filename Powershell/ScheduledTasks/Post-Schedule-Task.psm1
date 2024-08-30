<#
    .SYNOPSIS
    Creates a direct-support scheduled task against a specific device.

    .DESCRIPTION
    This function creates a direct-support scheduled task for immediate execution against a single device using the N-central API.

    .PARAMETER Name
    The name of the task. This value must be unique.

    .PARAMETER ItemId
    The ID of the remote execution item. The item ID can be found in the N-central UI and must have "Enable API" flag "ON".

    .PARAMETER TaskType
    The type of the task. Supported values: AutomationPolicy, Script, or MacScript.

    .PARAMETER CustomerId
    The ID of the customer. Can be obtained using the 'GET /api/customers' endpoint.

    .PARAMETER DeviceId
    The ID of the device. Can be obtained using the 'GET /api/devices' endpoint.

    .PARAMETER CredentialType
    The credential type. Supported values: LocalSystem, DeviceCredentials, or CustomCredentials.

    .PARAMETER Username
    The username (used with 'CustomCredentials' type).

    .PARAMETER Password
    The password (used with 'CustomCredentials' type).

    .PARAMETER Parameters
    An array of hashtables containing task parameters. Each hashtable should have 'name', 'value', 'description', and 'type' keys.

    .PARAMETER BaseURI
    The base URI for the N-central API.

    .PARAMETER AccessToken
    The access token for authentication.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    The function returns a JSON object containing the created task information.

    .NOTES
    Ensure you have the necessary permissions to create tasks in N-central.

    .CLASSIFICATION
    Destructive: No
    Potentially Long Running: No

    .EXAMPLE
    $params = @(
        @{
            name = "CommandLine"
            value = "killprocess.vbs /process:33022"
            description = "Command line to execute"
            type = "string"
        }
    )
    New-DirectSupportTask -Name "Test Task" -ItemId 1 -TaskType "Script" -CustomerId 100 -DeviceId 987654321 -CredentialType "LocalSystem" -Parameters $params -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/scheduled-tasks/direct endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    Other extra arguments are the BaseURI of the API endpoint and the AccessToken needed for authentication.
#>
function New-DirectSupportTask {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$ItemId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("AutomationPolicy", "Script", "MacScript")]
        [string]$TaskType,

        [Parameter(Mandatory = $true)]
        [int]$CustomerId,

        [Parameter(Mandatory = $true)]
        [int]$DeviceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("LocalSystem", "DeviceCredentials", "CustomCredentials")]
        [string]$CredentialType,

        [Parameter(Mandatory = $false)]
        [string]$Username,

        [Parameter(Mandatory = $false)]
        [string]$Password,

        [Parameter(Mandatory = $false)]
        [array]$Parameters,

        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken
    )

    # Build the request body
    $body = @{
        name = $Name
        itemId = $ItemId
        taskType = $TaskType
        customerId = $CustomerId
        deviceId = $DeviceId
        credential = @{
            type = $CredentialType
        }
    }

    # Add username and password if CustomCredentials type is used
    if ($CredentialType -eq "CustomCredentials") {
        if ([string]::IsNullOrEmpty($Username) -or [string]::IsNullOrEmpty($Password)) {
            throw "Username and Password are required when using CustomCredentials"
        }
        $body.credential.username = $Username
        $body.credential.password = $Password
    }

    # Add parameters if provided
    if ($Parameters) {
        $body.parameters = $Parameters
    }

    # Construct the URI
    $uri = "$BaseURI/api/scheduled-tasks/direct"

    # Set up headers
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    }

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body ($body | ConvertTo-Json -Depth 10)

        # Return the response
        return $response
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP Status Code: $statusCode - $statusDescription"
        Write-Error "Error Message: $_.Exception.Response"
    }
}