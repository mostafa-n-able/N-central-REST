def get_device_custom_properties(device_id, base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves custom properties for a specific device.

    .DESCRIPTION
    This function makes a GET request to the /api/devices/{deviceId}/custom-properties endpoint
    to retrieve the custom properties associated with a given device ID.

    .ARGUMENTS
    device_id: The ID of the device for which to retrieve custom properties.
    base_uri: The base URI of the API endpoint.
    access_token: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of custom properties for the specified device.

    .NOTES
    This endpoint is currently in a preview stage.

    .USAGE_EXAMPLE
    properties = get_device_custom_properties("123456", "https://api.example.com", "access_token_here")

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/custom-properties endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}/custom-properties"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        custom_properties = response.json()
        logger.info(f"Successfully retrieved custom properties for device {device_id}")
        return custom_properties

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise