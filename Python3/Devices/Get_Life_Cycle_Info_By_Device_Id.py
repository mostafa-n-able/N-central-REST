import requests
import logging

def get_device_asset_lifecycle_info(device_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieve asset lifecycle information for a specific device.

    DESCRIPTION
    This function makes a GET request to the /api/devices/{deviceId}/assets/lifecycle-info
    endpoint to retrieve asset lifecycle information for a given device.

    ARGUMENTS
    device_id   - The ID of the device for which to retrieve asset lifecycle information.
    base_uri    - The base URI of the API endpoint.
    access_token - The access token for authentication.

    OUTPUTS
    Returns a dictionary containing the asset lifecycle details if successful.
    Returns None if the request fails.

    NOTES
    - Requires valid authentication via the access_token.
    - Handles potential errors and logs them for debugging.

    USAGE_EXAMPLE
    asset_info = get_device_asset_lifecycle_info('123456', 'https://api.example.com', 'your_access_token')
    if asset_info:
        print(f"Asset Tag: {asset_info['assetTag']}")
        print(f"Warranty Expiry Date: {asset_info['warrantyExpiryDate']}")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/assets/lifecycle-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}/assets/lifecycle-info"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to: {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse and return the JSON response
        asset_lifecycle_info = response.json()
        logger.info("Successfully retrieved asset lifecycle information")
        return asset_lifecycle_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        return None

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return None