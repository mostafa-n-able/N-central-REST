def get_device_default_custom_property(BaseURI, AccessToken, orgUnitId, propertyId):
    """
    SYNOPSIS
    Retrieve Device Default Custom Property information by organization unit id and property id.

    DESCRIPTION
    This function retrieves the default custom property information for a device using the 
    specified organization unit ID and property ID.

    ARGUMENTS
    BaseURI      - The base URI for the API endpoint
    AccessToken  - The access token for authentication
    orgUnitId    - The ID of the organization unit
    propertyId   - The ID of the property

    OUTPUTS
    Returns a JSON object containing the device default custom property information.

    NOTES
    This endpoint is currently in a preview stage.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    org_unit_id = "123"
    property_id = "456"
    result = get_device_default_custom_property(base_uri, access_token, org_unit_id, property_id)
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/custom-properties/device-custom-property-defaults/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/org-units/{orgUnitId}/custom-properties/device-custom-property-defaults/{propertyId}"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Content-Type": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to: {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        result = response.json()
        logger.debug(f"Received response: {json.dumps(result, indent=2)}")

        return result

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        
        # Handle specific HTTP status codes
        if hasattr(e, 'response'):
            if e.response.status_code == 400:
                logger.error("Bad Request: Invalid input parameters")
            elif e.response.status_code == 401:
                logger.error("Unauthorized: Authentication failure")
            elif e.response.status_code == 403:
                logger.error("Forbidden: Insufficient permissions")
            elif e.response.status_code == 404:
                logger.error("Not Found: Organization Unit or Property not found")
            elif e.response.status_code == 500:
                logger.error("Internal Server Error")
        
        # Re-raise the exception for the caller to handle
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise