def get_org_unit_custom_property_default(org_unit_id, property_id, base_uri, access_token):
    """
    SYNOPSIS
    Retrieve the default custom property for an organization unit.

    DESCRIPTION
    This function retrieves the default custom property for a specific organization unit
    using the provided org unit ID and property ID.

    ARGUMENTS
    org_unit_id - Integer, the ID of the organization unit
    property_id - Integer, the ID of the custom property
    base_uri - String, the base URI of the API endpoint
    access_token - String, the access token for authentication

    OUTPUTS
    Returns a JSON object containing the default custom property information

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires API-Access Token for authentication.

    USAGE_EXAMPLE
    property_info = get_org_unit_custom_property_default(11090, 1624300373, "https://api.example.com", "your_access_token")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/org-custom-property-defaults/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/org-custom-property-defaults/{property_id}"

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
        property_info = response.json()
        logger.debug(f"Received response: {json.dumps(property_info, indent=2)}")

        return property_info

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