def get_device_scheduled_tasks(device_id, base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves a list of scheduled tasks associated with a specific device.

    .DESCRIPTION
    This function makes a GET request to the /api/devices/{deviceId}/scheduled-tasks endpoint
    to retrieve a list of scheduled tasks for a given device ID.

    .ARGUMENTS
    device_id: The ID of the device for which to retrieve scheduled tasks.
    base_uri: The base URI of the API endpoint.
    access_token: The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of scheduled tasks for the specified device.

    .NOTES
    This function requires the 'requests' library to be installed.

    .USAGE_EXAMPLE
    tasks = get_device_scheduled_tasks("123456", "https://api.example.com", "your_access_token")
    print(tasks)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/scheduled-tasks endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}/scheduled-tasks"

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

        # Parse the JSON response
        tasks = response.json()
        logger.debug(f"Successfully retrieved scheduled tasks for device ID: {device_id}")
        return tasks

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        return None

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return None