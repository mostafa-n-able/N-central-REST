import requests
import json
import logging

def get_org_unit_custom_property(org_unit_id, property_id, base_uri, access_token):
    """
    SYNOPSIS
        Retrieves a custom property for a specific organization unit.
    
    DESCRIPTION
        This function makes a GET request to the N-able API to retrieve details of a 
        specific custom property for a given organization unit.
    
    ARGUMENTS
        org_unit_id  : Integer - The ID of the organization unit
        property_id  : Integer - The ID of the custom property
        base_uri     : String - The base URI for the API
        access_token : String - The access token for authentication
    
    OUTPUTS
        Returns a JSON object containing the custom property details if successful.
        Returns None if the request fails.
    
    NOTES
        This function requires the 'requests' library to be installed.
        Error handling is implemented for common HTTP errors.
        Detailed debug logging is enabled.
    
    USAGE_EXAMPLE
        property_details = get_org_unit_custom_property(123, 456, "https://api.example.com", "your_access_token")
        if property_details:
            print(json.dumps(property_details, indent=2))
    
    PROMPT
        Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)
    
    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/custom-properties/{property_id}"
    
    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }
    
    logger.debug(f"Making GET request to: {url}")
    
    try:
        # Make the GET request
        response = requests.get(url, headers=headers)
        
        # Check if the request was successful
        response.raise_for_status()
        
        # Parse the JSON response
        custom_property = response.json()
        
        logger.debug(f"Successfully retrieved custom property: {custom_property}")
        
        return custom_property
    
    except requests.exceptions.HTTPError as http_err:
        logger.error(f"HTTP error occurred: {http_err}")
        if response.status_code == 400:
            logger.error("Bad request. Check the org_unit_id and property_id.")
        elif response.status_code == 401:
            logger.error("Authentication failed. Check your access token.")
        elif response.status_code == 403:
            logger.error("Forbidden. You don't have permission to access this resource.")
        elif response.status_code == 404:
            logger.error("Custom Property not found.")
        else:
            logger.error(f"Unexpected HTTP status code: {response.status_code}")
    except requests.exceptions.RequestException as req_err:
        logger.error(f"Request error occurred: {req_err}")
    except json.JSONDecodeError as json_err:
        logger.error(f"JSON decode error occurred: {json_err}")
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
    
    return None

# Example usage:
# custom_property = get_org_unit_custom_property(123, 456, "https://api.example.com", "your_access_token")
# if custom_property:
#     print(json.dumps(custom_property, indent=2))