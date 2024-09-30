def create_direct_support_task(base_uri, access_token, customer_id, device_id, item_id, name, task_type, credential, parameters):
    """
    SYNOPSIS
    Creates a direct support scheduled task for a specific device.

    DESCRIPTION
    This function creates a direct support scheduled task against a specific device using the
    POST /api/scheduled-tasks/direct endpoint. The task will be executed immediately on the specified device.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication
    customer_id : int
        The ID of the customer
    device_id : int
        The ID of the device
    item_id : int
        The ID of the remote execution item
    name : str
        The name of the task (must be unique)
    task_type : str
        The type of the task (AutomationPolicy, Script, or MacScript)
    credential : dict
        The credential settings for the task (type, username, password)
    parameters : list
        List of dictionaries containing task parameters (name, value)

    OUTPUTS
    dict
        A dictionary containing the created task information, including the task ID

    NOTES
    - Ensure that the item_id has the "Enable API" flag set to "ON" in the N-central UI.
    - The function uses the requests library for making HTTP requests.
    - Error handling is implemented to catch and report any issues during the API call.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    customer_id = 100
    device_id = 987654321
    item_id = 1
    name = "Test Task"
    task_type = "Script"
    credential = {"type": "LocalSystem"}
    parameters = [{"name": "CommandLine", "value": "killprocess.vbs /process:33022"}]

    result = create_direct_support_task(base_uri, access_token, customer_id, device_id, item_id, name, task_type, credential, parameters)
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/scheduled-tasks/direct endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/scheduled-tasks/direct"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Prepare the payload
    payload = {
        "customerId": customer_id,
        "deviceId": device_id,
        "itemId": item_id,
        "name": name,
        "taskType": task_type,
        "credential": credential,
        "parameters": parameters
    }

    logger.debug(f"Sending POST request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Payload: {json.dumps(payload, indent=2)}")

    try:
        # Make the POST request
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
            logger.error(f"Response body: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        logger.error(f"Raw response: {response.text}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        raise