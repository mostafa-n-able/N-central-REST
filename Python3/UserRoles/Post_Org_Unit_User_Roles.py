def add_user_role(org_unit_id, role_name, description, permission_ids, user_ids=None, base_uri=None, access_token=None):
    """
    SYNOPSIS
    Add a new user role for a given organization unit.

    DESCRIPTION
    This function creates a new user role for the specified organization unit using the POST /api/org-units/{orgUnitId}/user-roles endpoint.

    ARGUMENTS
    org_unit_id (str): ID of the organization unit for which new role needs to be added.
    role_name (str): The name of the role.
    description (str): The description of the role.
    permission_ids (list): List of permission IDs to be associated with the role.
    user_ids (list, optional): List of user IDs to be associated with the role.
    base_uri (str): The base URI for the API endpoint.
    access_token (str): The access token for authentication.

    OUTPUTS
    dict: A dictionary containing the response data, including the new role ID.

    NOTES
    - This endpoint is currently in a preview stage.
    - Ensure that the access token has the necessary permissions to create user roles.

    USAGE_EXAMPLE
    response = add_user_role(
        org_unit_id="123",
        role_name="New Admin Role",
        description="Administrator role with extended permissions",
        permission_ids=["1", "2", "3"],
        user_ids=["101", "102"],
        base_uri="https://api.example.com",
        access_token="your_access_token_here"
    )
    print(f"New role created with ID: {response['data']['roleId']}")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/org-units/{orgUnitId}/user-roles endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Validate required arguments
    if not all([org_unit_id, role_name, description, permission_ids, base_uri, access_token]):
        raise ValueError("Missing required arguments")

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/user-roles"

    # Prepare the request payload
    payload = {
        "roleName": role_name,
        "description": description,
        "permissionIds": permission_ids
    }

    # Add userIds to payload if provided
    if user_ids:
        payload["userIds"] = user_ids

    # Set up the headers
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    }

    try:
        # Make the POST request
        logger.debug(f"Sending POST request to {url}")
        response = requests.post(url, json=payload, headers=headers)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while making the request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        raise

    except Exception as e:
        logger.error(f"An unexpected error occurred: {str(e)}")
        raise