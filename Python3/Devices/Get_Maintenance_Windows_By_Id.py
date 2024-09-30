def get_device_maintenance_windows(deviceId, BaseURI, AccessToken):
    """
    SYNOPSIS
    Retrieves all maintenance windows for a given device.

    DESCRIPTION
    This function makes a GET request to the /api/devices/{deviceId}/maintenance-windows endpoint
    to retrieve all maintenance windows associated with the specified device.

    ARGUMENTS
    deviceId : str
        The ID of the device for which to retrieve maintenance windows.
    BaseURI : str
        The base URI of the API endpoint.
    AccessToken : str
        The access token for authentication.

    OUTPUTS
    dict
        A JSON object containing the list of maintenance windows for the device.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires authentication via API-Access Token.
    - Error handling is implemented for common HTTP status codes.

    USAGE_EXAMPLE
    device_id = "123456"
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    maintenance_windows = get_device_maintenance_windows(device_id, base_uri, access_token)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/maintenance-windows endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/devices/{deviceId}/maintenance-windows"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check for HTTP errors
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            status_code = e.response.status_code
            if status_code == 400:
                logger.error("Bad Request: Invalid input parameters")
            elif status_code == 401:
                logger.error("Unauthorized: Authentication failure")
            elif status_code == 403:
                logger.error("Forbidden: Insufficient permissions")
            elif status_code == 404:
                logger.error("Not Found: Device ID not found")
            elif status_code == 500:
                logger.error("Internal Server Error")
            else:
                logger.error(f"HTTP Error: {status_code}")
        else:
            logger.error("Unknown error occurred")
        return None

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return None