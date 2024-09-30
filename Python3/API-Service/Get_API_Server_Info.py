def get_server_info(base_uri, access_token):
    """
    SYNOPSIS
    Retrieves server information from the N-central API.

    DESCRIPTION
    This function makes a GET request to the /api/server-info endpoint of the N-central API
    to retrieve version information of the running API-Service.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token needed for authentication

    OUTPUTS
    dict
        A dictionary containing the server information, including jvmVersion, ncentral, and version

    NOTES
    - This function requires the requests library to be installed.
    - Error handling is implemented for common HTTP errors and connection issues.
    - Extensive debug logging is included to aid in troubleshooting.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    server_info = get_server_info(base_uri, access_token)
    print(server_info)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/server-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/server-info"

    # Set up headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    logger.debug(f"Making GET request to {url}")

    try:
        # Make the GET request
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        server_info = response.json()

        logger.debug(f"Received server info: {server_info}")

        return server_info

    except requests.exceptions.HTTPError as http_err:
        logger.error(f"HTTP error occurred: {http_err}")
        if response.status_code == 400:
            logger.error("Bad Request: The server could not understand the request.")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication failed or user lacks necessary permissions.")
        elif response.status_code == 403:
            logger.error("Forbidden: The server understood the request but refuses to authorize it.")
        elif response.status_code == 404:
            logger.error("Not Found: The requested resource could not be found.")
        elif response.status_code == 500:
            logger.error("Internal Server Error: The server encountered an unexpected condition.")
        raise

    except requests.exceptions.ConnectionError as conn_err:
        logger.error(f"Connection error occurred: {conn_err}")
        raise

    except requests.exceptions.Timeout as timeout_err:
        logger.error(f"Timeout error occurred: {timeout_err}")
        raise

    except requests.exceptions.RequestException as req_err:
        logger.error(f"An error occurred while making the request: {req_err}")
        raise

    except ValueError as val_err:
        logger.error(f"Error parsing JSON response: {val_err}")
        raise