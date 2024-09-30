def get_access_groups(base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves a list of access group related links.

    .DESCRIPTION
    This function calls the GET /api/access-groups endpoint to retrieve a list of access group related links.

    .ARGUMENTS
    base_uri - The base URI of the API endpoint
    access_token - The access token for authentication

    .OUTPUTS
    Returns a JSON object containing links to access group related endpoints.

    .NOTES
    This endpoint is currently in a preview stage.

    .USAGE_EXAMPLE
    links = get_access_groups("https://api.example.com", "your_access_token_here")
    print(links)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/access-groups"

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
        logger.debug(f"Received response: {json.dumps(data, indent=2)}")

        return data

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