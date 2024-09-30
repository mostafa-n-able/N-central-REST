def get_org_unit_access_groups(org_unit_id, base_uri, access_token, page_number=1, page_size=50, select=None, sort_by=None, sort_order="ASC"):
    """
    SYNOPSIS
    Retrieve Access Groups Information for an Org Unit by ID.

    DESCRIPTION
    This function retrieves access group information for a specific organization unit using the GET /api/org-units/{orgUnitId}/access-groups endpoint.

    ARGUMENTS
    org_unit_id  : string  - The ID of the organization unit for which to fetch access groups information.
    base_uri     : string  - The base URI of the API endpoint.
    access_token : string  - The access token for authentication.
    page_number  : integer - The page number to retrieve (default: 1).
    page_size    : integer - The number of items per page (default: 50).
    select       : string  - The select expression for filtering results (optional).
    sort_by      : string  - The field to sort the results by (optional).
    sort_order   : string  - The sort order, either "ASC" or "DESC" (default: "ASC").

    OUTPUTS
    Returns a JSON object containing the access groups information for the specified organization unit.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library to make the API call.
    - Error handling is implemented to catch and report any issues with the API request.

    USAGE_EXAMPLE
    access_groups = get_org_unit_access_groups("12345", "https://api.example.com", "your_access_token")
    print(access_groups)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/access-groups endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/access-groups"

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

    # Add optional parameters if provided
    if select:
        params["select"] = select
    if sort_by:
        params["sortBy"] = sort_by
    if sort_order:
        params["sortOrder"] = sort_order

    try:
        # Make the API request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers, params=params)
        
        # Check if the request was successful
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        raise

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise