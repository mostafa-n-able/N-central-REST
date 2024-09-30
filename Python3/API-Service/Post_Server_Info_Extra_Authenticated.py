def get_server_info_extra_authenticated(BaseURI, AccessToken, username, password):
    """
    .SYNOPSIS
    Retrieves extra information about the version of different systems in N-central using credentials.

    .DESCRIPTION
    This function makes an authenticated POST request to the N-central API to retrieve extra version information
    about different systems. It requires a username and password for authentication.

    .ARGUMENTS
    BaseURI: The base URI of the API endpoint
    AccessToken: The access token needed for authentication
    username: The username for authentication
    password: The password for authentication

    .OUTPUTS
    Returns a JSON object containing extra version information about different systems in N-central.

    .NOTES
    This endpoint is currently in a preview stage and may be subject to changes.

    .USAGE_EXAMPLE
    server_info = get_server_info_extra_authenticated("https://api.example.com", "your_access_token", "your_username", "your_password")
    print(server_info)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/server-info/extra/authenticated endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/server-info/extra/authenticated"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Content-Type": "application/json"
    }

    # Prepare the request body
    payload = {
        "username": username,
        "password": password
    }

    try:
        # Make the POST request
        logger.debug(f"Making POST request to {url}")
        response = requests.post(url, headers=headers, json=payload)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        server_info = response.json()

        logger.info("Successfully retrieved server info")
        return server_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        
        # Attempt to parse error response
        try:
            error_data = e.response.json()
            logger.error(f"Error details: {json.dumps(error_data, indent=2)}")
        except:
            logger.error("Could not parse error response as JSON")

        # Re-raise the exception
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise