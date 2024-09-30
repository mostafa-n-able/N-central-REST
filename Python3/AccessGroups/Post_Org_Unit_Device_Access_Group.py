def create_device_access_group(org_unit_id, group_name, group_description, device_ids=None, user_ids=None, base_uri=None, access_token=None):
    """
    SYNOPSIS
    Creates a new device type access group for a specified organization unit.

    DESCRIPTION
    This function creates a new device type access group with the specified details for a given organization unit.
    It uses the POST /api/org-units/{orgUnitId}/device-access-groups endpoint.

    ARGUMENTS
    org_unit_id (str): The ID of the organization unit where the access group will be created.
    group_name (str): The name of the access group to be created.
    group_description (str): The description of the access group.
    device_ids (list, optional): List of device IDs to attach to the access group.
    user_ids (list, optional): List of user IDs to be associated with the access group.
    base_uri (str): The base URI of the API endpoint.
    access_token (str): The access token for authentication.

    OUTPUTS
    dict: A dictionary containing the API response.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library to make the API call.
    - Error handling is implemented to catch and report any issues during the API call.

    USAGE_EXAMPLE
    response = create_device_access_group(
        org_unit_id="123",
        group_name="New Device Group",
        group_description="A sample device access group",
        device_ids=["1001", "1002"],
        user_ids=["5001", "5002"],
        base_uri="https://api.example.com",
        access_token="your_access_token_here"
    )
    print(response)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/org-units/{orgUnitId}/device-access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/device-access-groups"

    # Prepare the headers
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    }

    # Prepare the request body
    body = {
        "groupName": group_name,
        "groupDescription": group_description
    }

    if device_ids:
        body["deviceIds"] = device_ids
    if user_ids:
        body["userIds"] = user_ids

    # Log the request details
    logger.debug(f"Making POST request to: {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Request body: {json.dumps(body, indent=2)}")

    try:
        # Make the API call
        response = requests.post(url, headers=headers, json=body)
        
        # Check if the request was successful
        response.raise_for_status()

        # Log the response
        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response body: {response.text}")

        # Return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        # Log the error
        logger.error(f"An error occurred: {str(e)}")
        
        # If there's a response, log its content
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")

        # Re-raise the exception
        raise

    except json.JSONDecodeError as e:
        # Log the error if JSON parsing fails
        logger.error(f"Failed to parse JSON response: {str(e)}")
        raise

    except Exception as e:
        # Log any other unexpected errors
        logger.error(f"An unexpected error occurred: {str(e)}")
        raise