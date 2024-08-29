<#
.SYNOPSIS
Creates a URL query string from a dictionary of parameters.

.DESCRIPTION
The New-HttpQueryString function takes a hashtable of key-value pairs and converts them into a properly formatted URL query string.

.PARAMETER Parameters
A hashtable containing the key-value pairs to be converted into a query string.

.OUTPUTS
System.String. The function returns a formatted query string.

.NOTES

.EXAMPLE
$params = @{
    "name" = "John Doe"
    "age" = 30
    "city" = "New York"
}
$queryString = New-HttpQueryString -Parameters $params
# Output: ?name=John%20Doe&age=30&city=New%20York
#>

function New-HttpQueryString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [hashtable]$Parameters
    )

    begin {
        # Initialize an empty array to store the query string parts
        $queryParts = @()
    }

    process {
        try {
            # Iterate through each key-value pair in the Parameters hashtable
            foreach ($key in $Parameters.Keys) {
                $value = $Parameters[$key]

                # Check if the value is null or empty
                if ($null -ne $value -and $value -ne '') {
                    # URL encode both the key and value
                    $encodedKey = [System.Web.HttpUtility]::UrlEncode($key)
                    $encodedValue = [System.Web.HttpUtility]::UrlEncode($value.ToString())

                    # Add the encoded key-value pair to the queryParts array
                    $queryParts += "$encodedKey=$encodedValue"
                }
            }
        }
        catch {
            # If an error occurs during processing, throw an exception
            throw "Error processing parameters: $_"
        }
    }

    end {
        try {
            # Join all query parts with '&' and prepend '?'
            $queryString = if ($queryParts.Count -gt 0) {
                "?" + ($queryParts -join '&')
            }
            else {
                # Return an empty string if there are no valid parameters
                ""
            }

            # Return the final query string
            return $queryString
        }
        catch {
            # If an error occurs while constructing the final query string, throw an exception
            throw "Error constructing query string: $_"
        }
    }
}

Export-ModuleMember -Function New-HttpQueryString
