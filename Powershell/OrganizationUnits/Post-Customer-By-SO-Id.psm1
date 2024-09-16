<#
    .SYNOPSIS
    Creates a new customer under a specified service organization.

    .DESCRIPTION
    This function creates a new customer with the specified details under a given service organization using the N-able N-central API.

    .PARAMETER BaseURI
    The base URI for the N-able N-central API.

    .PARAMETER AccessToken
    The access token required for authentication.

    .PARAMETER SoId
    The ID of the service organization under which the customer will be created.

    .PARAMETER CustomerName
    The name of the customer to be created.

    .PARAMETER ContactFirstName
    The first name of the contact for the customer.

    .PARAMETER ContactLastName
    The last name of the contact for the customer.

    .PARAMETER LicenseType
    The license type for the customer. Defaults to "Professional" if not specified.

    .PARAMETER City
    The city where the customer is located.

    .PARAMETER Country
    The country where the customer is located (two-character country code).

    .PARAMETER ContactEmail
    The email address of the contact for the customer.

    .PARAMETER ContactPhone
    The phone number of the contact for the customer.

    .PARAMETER ExternalId
    The external ID for the customer.

    .PARAMETER PostalCode
    The postal code of the customer's location.

    .PARAMETER StateProv
    The state or province where the customer is located.

    .PARAMETER Street1
    The first line of the street address for the customer.

    .PARAMETER Street2
    The second line of the street address for the customer.

    .PARAMETER ContactDepartment
    The department of the contact for the customer.

    .PARAMETER ContactPhoneExt
    The phone extension of the contact for the customer.

    .PARAMETER ContactTitle
    The title of the contact for the customer.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. Returns the created customer object.

    .NOTES
    This function requires valid authentication and appropriate permissions to create customers.

    .EXAMPLE
    $newCustomer = New-NCentralCustomer -BaseURI "https://api.ncentral.com" -AccessToken "your_access_token" -SoId 123 -CustomerName "New Customer" -ContactFirstName "John" -ContactLastName "Doe" -LicenseType "Professional" -City "New York" -Country "US" -ContactEmail "john.doe@example.com"

    This example creates a new customer named "New Customer" under the service organization with ID 123.

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/service-orgs/{soId}/customers endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
#>
function New-NCentralCustomer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [string]$AccessToken,

        [Parameter(Mandatory = $true)]
        [string]$SoId,

        [Parameter(Mandatory = $true)]
        [string]$CustomerName,

        [Parameter(Mandatory = $true)]
        [string]$ContactFirstName,

        [Parameter(Mandatory = $true)]
        [string]$ContactLastName,

        [Parameter(Mandatory = $false)]
        [string]$LicenseType = "Professional",

        [Parameter(Mandatory = $false)]
        [string]$City,

        [Parameter(Mandatory = $false)]
        [string]$Country,

        [Parameter(Mandatory = $false)]
        [string]$ContactEmail,

        [Parameter(Mandatory = $false)]
        [string]$ContactPhone,

        [Parameter(Mandatory = $false)]
        [string]$ExternalId,

        [Parameter(Mandatory = $false)]
        [string]$PostalCode,

        [Parameter(Mandatory = $false)]
        [string]$StateProv,

        [Parameter(Mandatory = $false)]
        [string]$Street1,

        [Parameter(Mandatory = $false)]
        [string]$Street2,

        [Parameter(Mandatory = $false)]
        [string]$ContactDepartment,

        [Parameter(Mandatory = $false)]
        [string]$ContactPhoneExt,

        [Parameter(Mandatory = $false)]
        [string]$ContactTitle
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $endpoint = "$BaseURI/api/service-orgs/$SoId/customers"
        $headers = @{
            'Authorization' = "Bearer $AccessToken"
            'Content-Type' = 'application/json'
        }
    }

    process {
        try {
            # Construct the request body
            $body = @{
                customerName = $CustomerName
                contactFirstName = $ContactFirstName
                contactLastName = $ContactLastName
                licenseType = $LicenseType
            }

            # Add optional parameters to the body if they are provided
            $optionalParams = @('City', 'Country', 'ContactEmail', 'ContactPhone', 'ExternalId', 'PostalCode', 'StateProv', 'Street1', 'Street2', 'ContactDepartment', 'ContactPhoneExt', 'ContactTitle')
            foreach ($param in $optionalParams) {
                if ($PSBoundParameters.ContainsKey($param)) {
                    $body[$param.ToLower()] = $PSBoundParameters[$param]
                }
            }

            $jsonBody = $body | ConvertTo-Json

            Write-Debug "Sending POST request to $endpoint"
            Write-Debug "Request body: $jsonBody"

            # Send the request
            $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $jsonBody -ErrorVariable restError

            Write-Debug "Response received: $($response | ConvertTo-Json -Depth 4)"

            # Return the response as a JSON object
            return $response | ConvertTo-Json -Depth 4
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription

            Write-Error "HTTP $statusCode $statusDescription at $endpoint"
            Write-Debug "Error: $_"

            if ($restError) {
                Write-Error $restError.Message
            }
        }
    }
}