def get_api_health(base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves the health status of the API server.

    .DESCRIPTION
    This function makes a GET request to the /api/health endpoint to check the health status of the API server.
    It returns the current time of the server, indicating that the server is running.

    .ARGUMENTS
    base_uri - The base URI of the API endpoint
    access_token - The access token for authentication

    .OUTPUTS
    Returns a dictionary containing the current time of the server if successful.
    Returns None if the request fails.

    .NOTES
    This function requires the 'requests' library to be installed.

    .USAGE_EXAMPLE
    health_status = get_api_health("https://api.example.com", "your_access_token_here")
    if health_status:
        print(f"Server is healthy. Current time: {health_status['currentTime']}")
    else:
        print("Failed to retrieve server health status")

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/health endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/health"

    # Set up headers
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

        # Parse and return the JSON response
        health_data = response.json()
        logger.info("Successfully retrieved API health status")
        return health_data

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching API health: {str(e)}")
        return None

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {str(e)}")
        return None