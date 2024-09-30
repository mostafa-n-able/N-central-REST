def get_org_unit_custom_properties(org_unit_id, base_uri, access_token, page_number=1, page_size=50, select=None, sort_by=None, sort_order="ASC"):
    """
    SYNOPSIS
    Retrieve custom properties for an organization unit.

    DESCRIPTION
    This function retrieves a list of custom properties for a specified organization unit using the N-able API.

    ARGUMENTS
    org_unit_id   - Integer. The ID of the organization unit.
    base_uri      - String. The base URI of the API endpoint.
    access_token  - String. The access token for authentication.
    page_number   - Integer. The page number to retrieve (default: 1).
    page_size     - Integer. The number of items per page (default: 50).
    select        - String. The select expression for filtering results (optional).
    sort_by       - String. The field to sort the results by (optional).
    sort_order    - String. The sort order, either "ASC" or "DESC" (default: "ASC").

    OUTPUTS
    Returns a JSON object containing the list of custom properties for the specified organization unit.

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling is implemented for common HTTP errors.
    - The function uses extensive debug logging to track the API request and response.

    USAGE_EXAMPLE
    properties = get_org_unit_custom_properties(123, "https://api.example.com", "your_access_token")
    print(properties)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/custom-properties endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/custom-properties"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    # Set up the query parameters
    params = {
        "pageNumber": page_number,
        "pageSize": page_size
    }

    if select:
        params["select"] = select
    if sort_by:
        params["sortBy"] = sort_by
    if sort_order:
        params["sortOrder"] = sort_order

    # Log the request details
    logger.debug(f"Making GET request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Query parameters: {params}")

    try:
        # Make the GET request
        response = requests.get(url, headers=headers, params=params)
        
        # Check for successful response
        response.raise_for_status()

        # Log the response
        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response content: {response.text}")

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        # Log the error and re-raise it
        logger.error(f"Error occurred while making the request: {str(e)}")
        raise

    except ValueError as e:
        # Log the error if JSON parsing fails
        logger.error(f"Error parsing JSON response: {str(e)}")
        raise