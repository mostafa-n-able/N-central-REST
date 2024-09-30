def get_server_info_extra(base_uri, access_token):
    """
    SYNOPSIS
    Retrieves extra information about the version of different systems in N-central.

    DESCRIPTION
    This function makes a GET request to the /api/server-info/extra endpoint to retrieve
    additional version information about various systems in N-central.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token needed for authentication

    OUTPUTS
    dict
        A dictionary containing the extra server information

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires valid API-Access Token for authentication.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    server_info = get_server_info_extra(base_uri, access_token)
    print(server_info)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/server-info/extra endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/server-info/extra"

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
        server_info = response.json()

        logger.info("Successfully retrieved server info extra")
        return server_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise