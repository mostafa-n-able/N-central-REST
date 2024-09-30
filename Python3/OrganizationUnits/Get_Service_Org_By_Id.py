import requests
import json
import logging

def get_service_organization(soId, BaseURI, AccessToken):
    """
    SYNOPSIS
    Retrieve a service organization by ID.

    DESCRIPTION
    This function retrieves detailed information about a specific service organization
    using its ID. It makes a GET request to the /api/service-orgs/{soId} endpoint.

    ARGUMENTS
    soId : int
        The ID of the service organization to retrieve.
    BaseURI : str
        The base URL of the API endpoint.
    AccessToken : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the service organization details if successful.
        Returns None if the request fails.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires authentication with a valid access token.
    - Error handling is implemented for common HTTP status codes.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    so_id = 123
    result = get_service_organization(so_id, base_uri, access_token)
    if result:
        print(json.dumps(result, indent=2))
    else:
        print("Failed to retrieve service organization information.")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/service-orgs/{soId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/service-orgs/{soId}"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check the response status code
        if response.status_code == 200:
            logger.info("Successfully retrieved service organization information")
            return response.json()
        elif response.status_code == 400:
            logger.error("Bad Request: Invalid input or parameters")
        elif response.status_code == 401:
            logger.error("Authentication Failure: Invalid or expired access token")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions to access the resource")
        elif response.status_code == 404:
            logger.error(f"Service Organization with ID {soId} not found")
        elif response.status_code == 500:
            logger.error("Internal Server Error occurred")
        else:
            logger.error(f"Unexpected status code: {response.status_code}")

        # If we've reached this point, an error occurred
        logger.debug(f"Response content: {response.text}")
        return None

    except requests.RequestException as e:
        logger.error(f"Request failed: {str(e)}")
        return None