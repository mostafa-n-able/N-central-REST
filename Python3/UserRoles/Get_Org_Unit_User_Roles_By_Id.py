import requests
import json
import logging

def get_user_role(org_unit_id, user_role_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieve a user role for a given organization unit and user role id.

    DESCRIPTION
    This function retrieves detailed information about a specific user role
    within a given organization unit using the N-central API.

    ARGUMENTS
    org_unit_id (str): The ID of the organization unit.
    user_role_id (str): The ID of the user role.
    base_uri (str): The base URI for the API endpoint.
    access_token (str): The access token for authentication.

    OUTPUTS
    dict: A JSON object containing the user role details.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires API-Access Token for authentication.

    USAGE_EXAMPLE
    user_role = get_user_role("123", "456", "https://api.example.com", "your_access_token")
    print(json.dumps(user_role, indent=2))

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/user-roles/{userRoleId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/user-roles/{user_role_id}"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to: {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        user_role_data = response.json()
        logger.info("Successfully retrieved user role data")
        return user_role_data

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

# Example usage (commented out)
# try:
#     result = get_user_role("123", "456", "https://api.example.com", "your_access_token")
#     print(json.dumps(result, indent=2))
# except Exception as e:
#     print(f"An error occurred: {e}")