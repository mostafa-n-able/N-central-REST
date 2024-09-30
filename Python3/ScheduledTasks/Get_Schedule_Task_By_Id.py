def get_scheduled_task(task_id, base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves general information for a given scheduled task using the task ID.

    .DESCRIPTION
    This function makes a GET request to the /api/scheduled-tasks/{taskId} endpoint
    to retrieve general information about a specific scheduled task.

    .ARGUMENTS
    task_id : str
        The ID of the task for which information is to be retrieved.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token for authentication.

    .OUTPUTS
    dict
        A dictionary containing the task information if successful.

    .NOTES
    This function requires the 'requests' library to be installed.

    .USAGE_EXAMPLE
    task_info = get_scheduled_task('123456', 'https://api.example.com', 'your_access_token')

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks/{taskId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/scheduled-tasks/{task_id}"

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
        task_info = response.json()
        logger.info(f"Successfully retrieved task information for task ID: {task_id}")
        return task_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching task information: {str(e)}")
        if response.status_code == 400:
            logger.error("Bad Request: Invalid input parameters")
        elif response.status_code == 401:
            logger.error("Unauthorized: Invalid or expired access token")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions to access this resource")
        elif response.status_code == 404:
            logger.error(f"Not Found: Task with ID {task_id} does not exist")
        elif response.status_code == 500:
            logger.error("Internal Server Error: An unexpected error occurred on the server")
        else:
            logger.error(f"Unexpected status code: {response.status_code}")
        return None

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"An unexpected error occurred: {str(e)}")
        return None