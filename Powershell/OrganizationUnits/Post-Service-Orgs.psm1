<#
    .SYNOPSIS
    Creates a new service organization in N-central.

    .DESCRIPTION
    This function creates a new service organization (SO) using the N-central API. It sends a POST request to the /api/service-orgs endpoint with the provided service organization details.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns a JSON object containing the created service organization's ID.

    .NOTES
    Version: 1.0
    Author: Assistant
    Creation Date: 2023-06-09

    .EXAMPLE
    $newSO = New-ServiceOrganization -BaseURI "https://ncentral.mycompany.com" -AccessToken "your-access-token" -SoName "New SO" -ContactFirstName "John" -ContactLastName "Doe" -ContactEmail "john.doe@example.com"

    This example creates a new service organization named "New SO" with the specified contact details.

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/service-orgs endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function New-ServiceOrganization {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [string]$SoName,

        [Parameter(Mandatory = $true)]
        [string]$ContactFirstName,

        [Parameter(Mandatory = $true)]
        [string]$ContactLastName,

        [Parameter()]
        [string]$ContactEmail,

        [Parameter()]
        [string]$ContactPhone,

        [Parameter()]
        [string]$ContactPhoneExt,

        [Parameter()]
        [string]$ContactTitle,

        [Parameter()]
        [string]$ContactDepartment,

        [Parameter()]
        [string]$ExternalId,

        [Parameter()]
        [string]$Street1,

        [Parameter()]
        [string]$Street2,

        [Parameter()]
        [string]$City,

        [Parameter()]
        [string]$StateProv,

        [Parameter()]
        [string]$PostalCode,

        [Parameter()]
        [string]$Country
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/service-orgs"
        $headers = @{
            "Authorization" = "Bearer $AccessToken"
            "Content-Type" = "application/json"
        }
    }

    process {
        try {
            Write-Debug "Creating service organization with name: $SoName"

            # Construct the request body
            $body = @{
                soName = $SoName
                contactFirstName = $ContactFirstName
                contactLastName = $ContactLastName
            }

            # Add optional parameters if they are provided
            if ($ContactEmail) { $body.contactEmail = $ContactEmail }
            if ($ContactPhone) { $body.contactPhone = $ContactPhone }
            if ($ContactPhoneExt) { $body.contactPhoneExt = $ContactPhoneExt }
            if ($ContactTitle) { $body.contactTitle = $ContactTitle }
            if ($ContactDepartment) { $body.contactDepartment = $ContactDepartment }
            if ($ExternalId) { $body.externalId = $ExternalId }
            if ($Street1) { $body.street1 = $Street1 }
            if ($Street2) { $body.street2 = $Street2 }
            if ($City) { $body.city = $City }
            if ($StateProv) { $body.stateProv = $StateProv }
            if ($PostalCode) { $body.postalCode = $PostalCode }
            if ($Country) { $body.country = $Country }

            $jsonBody = $body | ConvertTo-Json

            Write-Debug "Sending POST request to $endpoint"
            $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $jsonBody -ErrorAction Stop

            Write-Debug "Service organization created successfully"
            return $response
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "Failed to create service organization. Status code: $statusCode. Description: $statusDescription"

            if ($statusCode -eq 401) {
                Write-Warning "Authentication failed. Please check your access token."
            }
            elseif ($statusCode -eq 400) {
                Write-Warning "Bad request. Please check your input parameters."
            }
            elseif ($statusCode -eq 404) {
                Write-Warning "Endpoint not found. Please check your Base URI."
            }

            throw $_
        }
    }
}