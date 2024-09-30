def get_task_status_details(taskId, BaseURI, AccessToken):
    """
    .SYNOPSIS
    Retrieves detailed status per device for a given task.

    .DESCRIPTION
    This function makes a GET request to the /api/scheduled-tasks/{taskId}/status/details endpoint
    to retrieve a list of detailed statuses for each device associated with the given task.

    .ARGUMENTS
    taskId : string
        ID of the task for which detailed status needs to be fetched.
    BaseURI : string
        The base URI for the API endpoint.
    AccessToken : string
        The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the detailed status information for the specified task.

    .NOTES
    This function requires the 'requests' library to be installed.

    .USAGE_EXAMPLE
    task_details = get_task_status_details("123456", "https://api.example.com", "your_access_token_here")
    print(task_details)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks/{taskId}/status/details endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/scheduled-tasks/{taskId}/status/details"

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
        task_details = response.json()
        logger.debug(f"Received response: {json.dumps(task_details, indent=2)}")

        return task_details

    except requests.exceptions.RequestException as e:
        logger.error(f"An error occurred while making the request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        return None

    except json.JSONDecodeError as e:
        logger.error(f"Failed to parse JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"An unexpected error occurred: {str(e)}")
        return None