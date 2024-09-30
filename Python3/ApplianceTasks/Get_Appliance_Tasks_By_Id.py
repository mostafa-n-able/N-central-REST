import requests
import logging

def get_appliance_task_information(taskId, BaseURI, AccessToken):
    """
    SYNOPSIS
    Retrieves the appliance-task information for a given taskId.

    DESCRIPTION
    This function makes a GET request to the /api/appliance-tasks/{taskId} endpoint
    to fetch information about a specific appliance task.

    ARGUMENTS
    taskId : str
        The ID of the appliance-task for which information needs to be fetched.
    BaseURI : str
        The base URI of the API endpoint.
    AccessToken : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the appliance task information.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires authentication via the AccessToken.
    - Handles various HTTP status codes and errors.

    USAGE_EXAMPLE
    task_info = get_appliance_task_information("123456", "https://api.example.com", "your_access_token")
    print(task_info)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/appliance-tasks/{taskId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/appliance-tasks/{taskId}"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check the response status code
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
                logger.error("Authentication Failure: Invalid or missing AccessToken")
            elif status_code == 403:
                logger.error("Forbidden: Insufficient permissions")
            elif status_code == 404:
                logger.error("Not Found: Invalid taskId")
            elif status_code == 500:
                logger.error("Internal Server Error")
            else:
                logger.error(f"Unexpected status code: {status_code}")
        else:
            logger.error("Unknown error occurred")
        return None

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return None