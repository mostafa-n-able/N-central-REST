def get_org_unit(org_unit_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieve an organization unit by ID.

    DESCRIPTION
    This function retrieves detailed information about a specific organization unit
    using its ID. It makes a GET request to the N-central API endpoint.

    ARGUMENTS
    org_unit_id : int
        The ID of the organization unit to retrieve.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the organization unit details.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires authentication with a valid access token.
    - Error handling is implemented for common HTTP status codes.

    USAGE_EXAMPLE
    base_uri = "https://api.ncentral.com"
    access_token = "your_access_token_here"
    org_unit_id = 12345
    org_unit_info = get_org_unit(org_unit_id, base_uri, access_token)
    print(org_unit_info)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        # Handle request exceptions
        logger.error(f"Request failed: {str(e)}")
        if response.status_code == 400:
            logger.error("Bad Request: Invalid input parameters")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication failure")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions")
        elif response.status_code == 404:
            logger.error(f"Not Found: Organization Unit with ID {org_unit_id} not found")
        elif response.status_code == 500:
            logger.error("Internal Server Error")
        else:
            logger.error(f"Unexpected status code: {response.status_code}")
        return None

    except ValueError as e:
        # Handle JSON decoding errors
        logger.error(f"Failed to parse JSON response: {str(e)}")
        return None