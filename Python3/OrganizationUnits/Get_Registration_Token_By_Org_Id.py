def get_org_unit_registration_token(BaseURI, AccessToken, orgUnitId):
    """
    .SYNOPSIS
    Retrieves the registration token for a specific organization unit.

    .DESCRIPTION
    This function makes a GET request to the N-able N-central API to retrieve
    the registration token for a given organization unit ID.

    .ARGUMENTS
    BaseURI: string
        The base URL of the N-able N-central API.
    AccessToken: string
        The access token for authentication.
    orgUnitId: int
        The ID of the organization unit for which to retrieve the registration token.

    .OUTPUTS
    dict
        A dictionary containing the registration token information.

    .NOTES
    This function is part of the N-able N-central API integration.
    It requires a valid access token for authentication.
    The endpoint is currently in a preview stage.

    .USAGE_EXAMPLE
    base_uri = "https://api.ncentral.com"
    access_token = "your_access_token_here"
    org_unit_id = 12345
    result = get_org_unit_registration_token(base_uri, access_token, org_unit_id)
    print(result)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/registration-token endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/org-units/{orgUnitId}/registration-token"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        result = response.json()
        logger.debug(f"Received response: {result}")

        return result

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        
        # Handle specific error codes
        if hasattr(e, 'response'):
            if e.response.status_code == 400:
                logger.error("Bad Request: Invalid orgUnitId format or other input error.")
            elif e.response.status_code == 401:
                logger.error("Unauthorized: Invalid or missing access token.")
            elif e.response.status_code == 403:
                logger.error("Forbidden: Not allowed to access this resource.")
            elif e.response.status_code == 404:
                logger.error("Not Found: Organization unit not found.")
            elif e.response.status_code == 500:
                logger.error("Internal Server Error: Unexpected error occurred on the server.")
        
        # Re-raise the exception to be handled by the caller
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise