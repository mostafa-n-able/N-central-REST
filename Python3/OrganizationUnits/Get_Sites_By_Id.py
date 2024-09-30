def get_site_by_id(site_id, base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves information about a specific site by its ID.

    .DESCRIPTION
    This function makes a GET request to the /api/sites/{siteId} endpoint to retrieve
    detailed information about a specific site. It requires the site ID, base URI of
    the API, and an access token for authentication.

    .ARGUMENTS
    site_id : int
        The unique identifier of the site to retrieve.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token for authentication.

    .OUTPUTS
    dict
        A dictionary containing the site information if successful.

    .NOTES
    This endpoint is currently in a preview stage and may be subject to changes.

    .USAGE_EXAMPLE
    site_info = get_site_by_id(12345, "https://api.example.com", "your_access_token")
    print(site_info)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/sites/{siteId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/sites/{site_id}"

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
        site_info = response.json()
        logger.info(f"Successfully retrieved information for site ID {site_id}")
        return site_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching site information: {str(e)}")
        if response.status_code == 400:
            logger.error("Bad Request: Invalid input parameters")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication failure")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions")
        elif response.status_code == 404:
            logger.error(f"Not Found: Site with ID {site_id} does not exist")
        elif response.status_code == 500:
            logger.error("Internal Server Error")
        else:
            logger.error(f"Unexpected status code: {response.status_code}")
        return None

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        return None