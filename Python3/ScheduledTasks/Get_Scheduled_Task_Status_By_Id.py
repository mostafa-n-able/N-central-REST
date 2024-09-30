def get_task_status(task_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieves the aggregated status associated with a given task using the task ID.

    DESCRIPTION
    This function makes a GET request to the /api/scheduled-tasks/{taskId}/status endpoint
    to retrieve the aggregated status of a specific task.

    ARGUMENTS
    task_id : str
        The ID of the task for which to retrieve the aggregated status.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the aggregated status response for the task.

    NOTES
    - Requires the requests library to be installed.
    - Handles potential errors and raises exceptions with descriptive messages.
    - Uses debug logging to provide detailed information about the request and response.

    USAGE_EXAMPLE
    task_status = get_task_status("123456", "https://api.example.com", "your_access_token")
    print(task_status)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks/{taskId}/status endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/scheduled-tasks/{task_id}/status"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    logger.debug(f"Making GET request to: {url}")
    logger.debug(f"Headers: {headers}")

    try:
        # Make the GET request
        response = requests.get(url, headers=headers)
        
        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        task_status = response.json()

        logger.debug(f"Response received: {task_status}")
        return task_status

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while making the request: {str(e)}")
        if response.status_code == 400:
            raise ValueError("Bad Request: Invalid task ID or request parameters.")
        elif response.status_code == 401:
            raise ValueError("Authentication Failure: Invalid or expired access token.")
        elif response.status_code == 403:
            raise ValueError("Forbidden: You don't have permission to access this resource.")
        elif response.status_code == 404:
            raise ValueError(f"Not Found: Task with ID {task_id} not found.")
        elif response.status_code == 500:
            raise ValueError("Internal Server Error: Something went wrong on the server side.")
        else:
            raise ValueError(f"Request failed with status code: {response.status_code}")

    except ValueError as json_error:
        logger.error(f"Error parsing JSON response: {str(json_error)}")
        raise ValueError("Invalid JSON response received from the server.")

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        raise