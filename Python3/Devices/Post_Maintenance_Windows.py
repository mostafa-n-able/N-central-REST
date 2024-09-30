def add_maintenance_windows(base_uri, access_token, device_ids, maintenance_windows):
    """
    SYNOPSIS
    Add maintenance windows to specified devices.

    DESCRIPTION
    This function adds a set of maintenance windows to a list of given devices using the N-central API.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication
    device_ids : list
        List of device IDs to add maintenance windows to
    maintenance_windows : list
        List of maintenance window configurations

    OUTPUTS
    dict
        A dictionary containing the API response

    NOTES
    This function is currently in PREVIEW stage.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    device_ids = [123456789, 234567890]
    maintenance_windows = [
        {
            "applicableAction": [{"actions": [{"Key": "detect", "Value": None}], "type": "Patch"}],
            "cron": "0 0 0 ? 2 1,4 *",
            "downtimeOnAction": False,
            "duration": 60,
            "enabled": True,
            "maxDowntime": 0,
            "messageSender": None,
            "messageSenderEnabled": False,
            "name": "Test Maintenance Window",
            "preserveStateEnabled": False,
            "rebootDelay": 0,
            "rebootMethod": "allowUserToPostpone",
            "type": "action",
            "userMessage": None,
            "userMessageEnabled": False
        }
    ]
    response = add_maintenance_windows(base_uri, access_token, device_ids, maintenance_windows)
    print(response)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/devices/maintenance-windows endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/maintenance-windows"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Prepare the payload
    payload = {
        "deviceIDs": device_ids,
        "maintenanceWindows": maintenance_windows
    }

    logger.debug(f"Sending POST request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Payload: {json.dumps(payload, indent=2)}")

    try:
        # Send the POST request
        response = requests.post(url, headers=headers, json=payload)
        
        # Check if the request was successful
        response.raise_for_status()
        
        # Parse the JSON response
        result = response.json()
        
        logger.debug(f"Received response: {json.dumps(result, indent=2)}")
        return result

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while making the request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        
        # Attempt to return a structured error response
        error_response = {
            "error": str(e),
            "status_code": e.response.status_code if hasattr(e, 'response') and e.response is not None else None,
            "details": e.response.text if hasattr(e, 'response') and e.response is not None else None
        }
        return error_response

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return {"error": "Failed to decode JSON response", "details": str(e)}

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        return {"error": "An unexpected error occurred", "details": str(e)}