def get_org_unit_users(org_unit_id, base_uri, access_token, page_number=1, page_size=50, select=None, sort_by=None, sort_order="ASC"):
    """
     SYNOPSIS
    Retrieve the list of users for a specific organization unit.

    DESCRIPTION
    This function retrieves a list of users within a specified organization unit using the N-able API.
    It supports pagination, sorting, and field selection.

    ARGUMENTS
    org_unit_id  : string  - The ID of the org unit for which to retrieve the users.
    base_uri     : string  - The base URI of the API endpoint.
    access_token : string  - The access token for authentication.
    page_number  : integer - The page number to retrieve (default: 1).
    page_size    : integer - The number of items per page (default: 50, use -1 for all).
    select       : string  - The select expression for field filtering (optional).
    sort_by      : string  - The field to sort the results by (optional).
    sort_order   : string  - The sort order, either "ASC" or "DESC" (default: "ASC").

    OUTPUTS
    Returns a JSON object containing the list of users and pagination information.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library for making HTTP requests.
    - Error handling is implemented for common HTTP errors.

    USAGE_EXAMPLE
    users = get_org_unit_users("12345", "https://api.example.com", "your_access_token")
    print(users)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/users endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object
    """

    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/users"

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
    logger.debug(f"Making GET request to: {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Query parameters: {params}")

    try:
        # Make the GET request with the constructed URL, headers, and parameters
        response = requests.get(url, headers=headers, params=params)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        raise

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise