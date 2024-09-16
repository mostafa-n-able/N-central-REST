<#
    .SYNOPSIS
    Creates a new site for a specified customer.

    .DESCRIPTION
    This function creates a new site for a given customer using the N-able N-central API. It sends a POST request to the /api/customers/{customerId}/sites endpoint with the provided site details.

    .INPUTS
    - CustomerId: The ID of the customer for which the site is being created.
    - SiteName: The name of the new site.
    - ContactFirstName: First name of the contact for the site.
    - ContactLastName: Last name of the contact for the site.
    - LicenseType: License type of the site (default is "Professional").
    - Other optional parameters as specified in the SiteCreation schema.

    .OUTPUTS
    Returns a custom object containing the newly created site's ID.

    .NOTES
    This function requires the BaseURI of the N-central server and a valid AccessToken for authentication.

    .EXAMPLE
    $newSite = New-NcentralCustomerSite -BaseURI "https://ncentral.example.com" -AccessToken "your_access_token" -CustomerId 12345 -SiteName "New Site" -ContactFirstName "John" -ContactLastName "Doe"

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/customers/{customerId}/sites endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function New-NcentralCustomerSite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [int]$CustomerId,

        [Parameter(Mandatory = $true)]
        [string]$SiteName,

        [Parameter(Mandatory = $true)]
        [string]$ContactFirstName,

        [Parameter(Mandatory = $true)]
        [string]$ContactLastName,

        [Parameter(Mandatory = $false)]
        [string]$LicenseType = "Professional",

        [Parameter(Mandatory = $false)]
        [string]$ContactEmail,

        [Parameter(Mandatory = $false)]
        [string]$ContactPhone,

        [Parameter(Mandatory = $false)]
        [string]$ContactPhoneExt,

        [Parameter(Mandatory = $false)]
        [string]$ContactTitle,

        [Parameter(Mandatory = $false)]
        [string]$ContactDepartment,

        [Parameter(Mandatory = $false)]
        [string]$ExternalId,

        [Parameter(Mandatory = $false)]
        [string]$Street1,

        [Parameter(Mandatory = $false)]
        [string]$Street2,

        [Parameter(Mandatory = $false)]
        [string]$City,

        [Parameter(Mandatory = $false)]
        [string]$StateProv,

        [Parameter(Mandatory = $false)]
        [string]$PostalCode,

        [Parameter(Mandatory = $false)]
        [string]$Country,

        [Parameter(Mandatory = $false)]
        [string]$Phone
    )

    $ErrorActionPreference = 'Stop'

    # Construct the full URI
    $uri = "${BaseURI}/api/customers/${CustomerId}/sites"

    # Prepare the request body
    $body = @{
        siteName = $SiteName
        contactFirstName = $ContactFirstName
        contactLastName = $ContactLastName
        licenseType = $LicenseType
    }

    # Add optional parameters to the body if they are provided
    $optionalParams = @('ContactEmail', 'ContactPhone', 'ContactPhoneExt', 'ContactTitle', 'ContactDepartment', 'ExternalId', 'Street1', 'Street2', 'City', 'StateProv', 'PostalCode', 'Country', 'Phone')
    foreach ($param in $optionalParams) {
        if ($PSBoundParameters.ContainsKey($param)) {
            $body[$param.ToLower()] = $PSBoundParameters[$param]
        }
    }

    # Prepare the request headers
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Content-Type' = 'application/json'
    }

    try {
        # Send the POST request
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body ($body | ConvertTo-Json) -ErrorVariable restError

        # Return the response as a JSON object
        return $response | ConvertTo-Json
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Error "HTTP $statusCode $statusDescription at $uri"
        
        if ($restError) {
            Write-Error $restError.Message
        }
    }
}