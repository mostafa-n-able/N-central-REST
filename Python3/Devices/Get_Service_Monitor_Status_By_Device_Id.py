def get_device_service_monitor_status(deviceId, BaseURI, AccessToken):
    """
    SYNOPSIS
    Retrieves the status of the service monitoring tasks for a given device.

    DESCRIPTION
    This function makes a GET request to the /api/devices/{deviceId}/service-monitor-status
    endpoint to retrieve the status of service monitoring tasks for a specified device.

    ARGUMENTS
    deviceId (str): The ID of the device for which to retrieve the service monitor status.
    BaseURI (str): The base URI of the API endpoint.
    AccessToken (str): The access token for authentication.

    OUTPUTS
    dict: A dictionary containing the service monitoring status information.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires API-Access Token for authentication.

    USAGE_EXAMPLE
    status = get_device_service_monitor_status("123456", "https://api.example.com", "your_access_token")
    print(status)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId}/service-monitor-status endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/devices/{deviceId}/service-monitor-status"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to: {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()
        logger.debug("Successfully retrieved service monitor status")
        return data

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        
        # Handle specific HTTP status codes
        if isinstance(e, requests.exceptions.HTTPError):
            if e.response.status_code == 400:
                logger.error("Bad Request: Invalid input parameters")
            elif e.response.status_code == 401:
                logger.error("Unauthorized: Authentication failure")
            elif e.response.status_code == 403:
                logger.error("Forbidden: Insufficient permissions")
            elif e.response.status_code == 404:
                logger.error("Not Found: Device ID not found")
            elif e.response.status_code == 500:
                logger.error("Internal Server Error")
        
        # Return None or raise an exception based on your error handling strategy
        return None

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return None