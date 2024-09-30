def update_org_unit_custom_property(org_unit_id, property_id, value, base_uri, access_token):
    """
    SYNOPSIS
        Updates a custom property for an organization unit.
    
    DESCRIPTION
        This function updates the value of a custom property for a specific organization unit
        using the PUT /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint.
    
    ARGUMENTS
        org_unit_id (int): The ID of the organization unit.
        property_id (int): The ID of the custom property to update.
        value (str): The new value for the custom property.
        base_uri (str): The base URI of the API endpoint.
        access_token (str): The access token for authentication.
    
    OUTPUTS
        dict: A dictionary containing the response data, including any warnings.
    
    NOTES
        - This function requires the requests library to be installed.
        - Error handling is implemented for various HTTP status codes.
        - Debug logging is included to track the request and response.
    
    USAGE_EXAMPLE
        base_uri = "https://api.example.com"
        access_token = "your_access_token_here"
        result = update_org_unit_custom_property(123, 456, "New Value", base_uri, access_token)
        print(result)
    
    PROMPT
        Read the OpenAPI Spec and using the details and parameters for the PUT /api/org-units/{orgUnitId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/custom-properties/{property_id}"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Prepare the request body
    body = {
        "value": value
    }

    logger.debug(f"Sending PUT request to {url}")
    logger.debug(f"Request headers: {headers}")
    logger.debug(f"Request body: {body}")

    try:
        # Send the PUT request
        response = requests.put(url, headers=headers, json=body)
        
        # Check for successful response
        response.raise_for_status()

        # Parse the response JSON
        result = response.json()

        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response body: {result}")

        return result

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while making the request: {str(e)}")
        
        if hasattr(e, 'response') and e.response is not None:
            status_code = e.response.status_code
            error_message = e.response.text
            logger.error(f"Status code: {status_code}")
            logger.error(f"Error message: {error_message}")

            if status_code == 400:
                raise ValueError("Bad request. Please check your input parameters.")
            elif status_code == 401:
                raise ValueError("Authentication failed. Please check your access token.")
            elif status_code == 403:
                raise ValueError("Forbidden. You don't have permission to update this custom property.")
            elif status_code == 404:
                raise ValueError("Organization unit or custom property not found.")
            elif status_code == 500:
                raise ValueError("Internal server error occurred. Please try again later.")
        
        raise

    except ValueError as ve:
        logger.error(f"Value error occurred: {str(ve)}")
        raise

    except Exception as ex:
        logger.error(f"Unexpected error occurred: {str(ex)}")
        raise