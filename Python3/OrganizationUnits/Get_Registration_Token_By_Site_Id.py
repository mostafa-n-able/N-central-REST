def get_site_registration_token(site_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieve a site registration token.

    DESCRIPTION
    This function retrieves the registration token for a specific site using the provided site ID.

    ARGUMENTS
    site_id : str
        The ID of the site for which to retrieve the registration token.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the registration token information.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires API-Access Token authentication.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    site_id = "12345"
    result = get_site_registration_token(site_id, base_uri, access_token)
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/sites/{siteId}/registration-token endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/sites/{site_id}/registration-token"

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
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        
        # Handle specific error codes
        if isinstance(e, requests.exceptions.HTTPError):
            if e.response.status_code == 400:
                logger.error("Bad Request: Invalid input parameters")
            elif e.response.status_code == 401:
                logger.error("Unauthorized: Authentication failure")
            elif e.response.status_code == 403:
                logger.error("Forbidden: Insufficient permissions")
            elif e.response.status_code == 404:
                logger.error("Not Found: Site ID not found")
            elif e.response.status_code == 500:
                logger.error("Internal Server Error")
        
        # Re-raise the exception for the caller to handle
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise