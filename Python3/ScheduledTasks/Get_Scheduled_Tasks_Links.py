def get_scheduled_tasks(base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves links to scheduled task-related endpoints.

    .DESCRIPTION
    This function makes a GET request to the /api/scheduled-tasks endpoint to retrieve links
    related to scheduled tasks in the N-central API.

    .ARGUMENTS
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token needed for authentication.

    .OUTPUTS
    dict
        A JSON object containing links to scheduled task-related endpoints.

    .NOTES
    This function requires the requests library to be installed.

    .USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    result = get_scheduled_tasks(base_uri, access_token)
    print(result)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/scheduled-tasks endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/scheduled-tasks"

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
        data = response.json()
        logger.debug(f"Received response: {data}")

        return data

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        # You might want to re-raise the exception or handle it differently
        raise

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        # You might want to re-raise the exception or handle it differently
        raise