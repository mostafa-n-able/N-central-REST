def get_users(base_uri, access_token):
    """
    SYNOPSIS
    Retrieve the list of user-related links.

    DESCRIPTION
    This function makes a GET request to the /api/users endpoint to retrieve
    the list of user-related links.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication

    OUTPUTS
    dict
        A dictionary containing the user-related links

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires API-Access Token for authentication.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    user_links = get_users(base_uri, access_token)
    print(user_links)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/users endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/users"

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
        logger.info("Successfully retrieved user-related links")
        return data

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if response is not None:
            logger.error(f"Response status code: {response.status_code}")
            logger.error(f"Response content: {response.text}")
        raise

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise