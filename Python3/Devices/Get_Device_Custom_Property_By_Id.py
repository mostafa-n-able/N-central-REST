import requests
import logging

def get_device_custom_property(deviceId, propertyId, BaseURI, AccessToken):
    """
    SYNOPSIS
    Retrieve a specific custom property for a device.

    DESCRIPTION
    This function retrieves information about a specific custom property for a given device
    using the N-central API. It requires the device ID, property ID, base URI of the API,
    and an access token for authentication.

    ARGUMENTS
    deviceId    - The ID of the device (integer)
    propertyId  - The ID of the custom property (integer)
    BaseURI     - The base URI of the N-central API
    AccessToken - The access token for authentication

    OUTPUTS
    Returns a JSON object containing the custom property information if successful.
    Returns None if the request fails.

    NOTES
    This function is part of the PREVIEW API and may be subject to changes.

    USAGE_EXAMPLE
    custom_property = get_device_custom_property(1234, 5678, "https://api.ncentral.com", "your_access_token")
    if custom_property:
        print(f"Custom property name: {custom_property['propertyName']}")
        print(f"Custom property value: {custom_property['value']}")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/devices/{deviceId}/custom-properties/{propertyId}"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        return None

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return None