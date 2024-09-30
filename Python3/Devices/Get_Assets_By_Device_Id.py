def get_device_asset_info(device_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieve Asset Information for a device by ID.

    DESCRIPTION
    This function retrieves complete asset information for a device with a specific id.

    ARGUMENTS
    device_id : str
        The ID of the device for which asset information needs to be fetched.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token needed for authentication.

    OUTPUTS
    dict
        A dictionary containing the device asset information.

    NOTES
    - This function requires the requests library to be installed.
    - Error handling is implemented for common HTTP status codes.
    - Extensive debug logging is included.

    USAGE_EXAMPLE
    asset_info = get_device_asset_info("123456", "https://api.example.com", "your_access_token_here")
    print(asset_info)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/assets endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}/assets"

    # Set up headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    logger.debug(f"Sending GET request to: {url}")
    logger.debug(f"Headers: {headers}")

    try:
        # Send the GET request
        response = requests.get(url, headers=headers)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        asset_info = response.json()
        logger.debug(f"Received asset info: {asset_info}")
        return asset_info

    except requests.exceptions.HTTPError as http_err:
        logger.error(f"HTTP error occurred: {http_err}")
        if response.status_code == 400:
            logger.error("Bad Request: Invalid input parameters")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication failure")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions")
        elif response.status_code == 404:
            logger.error("Not Found: Device ID not found")
        else:
            logger.error(f"Unexpected HTTP status code: {response.status_code}")
        return None

    except requests.exceptions.RequestException as req_err:
        logger.error(f"Request error occurred: {req_err}")
        return None

    except ValueError as json_err:
        logger.error(f"JSON parsing error: {json_err}")
        return None

    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return None