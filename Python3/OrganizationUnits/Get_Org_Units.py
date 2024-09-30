def get_organization_units(base_uri, access_token, page_number=None, page_size=None, select=None, sort_by=None, sort_order=None):
    """
    SYNOPSIS
    Retrieve a list of all organization units.

    DESCRIPTION
    This function retrieves a list of all organization units using the GET /api/org-units endpoint.
    It supports pagination, sorting, and field selection.

    ARGUMENTS
    base_uri (str): The base URI of the API endpoint.
    access_token (str): The access token for authentication.
    page_number (int, optional): The page number to retrieve. Starts at 1.
    page_size (int, optional): The number of items to retrieve per page. Set to -1 to retrieve all items without pagination.
    select (str, optional): The select expression for field filtering.
    sort_by (str, optional): The name of a field to sort the result by.
    sort_order (str, optional): The order in which to sort (asc, ascending, natural, desc, descending, reverse).

    OUTPUTS
    dict: A dictionary containing the list of organization units and pagination information.

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling is implemented for common HTTP status codes.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    result = get_organization_units(base_uri, access_token, page_number=1, page_size=50, sort_by="orgUnitName", sort_order="asc")
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    # Set up the query parameters
    params = {}
    if page_number is not None:
        params["pageNumber"] = page_number
    if page_size is not None:
        params["pageSize"] = page_size
    if select is not None:
        params["select"] = select
    if sort_by is not None:
        params["sortBy"] = sort_by
    if sort_order is not None:
        params["sortOrder"] = sort_order

    # Make the API request
    try:
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        return {"error": str(e)}

    # Check the response status code
    if response.status_code == 200:
        logger.info("Successfully retrieved organization units")
        return response.json()
    elif response.status_code == 400:
        logger.error("Bad Request: Invalid input parameters")
        return {"error": "Bad Request"}
    elif response.status_code == 401:
        logger.error("Unauthorized: Invalid or missing access token")
        return {"error": "Unauthorized"}
    elif response.status_code == 403:
        logger.error("Forbidden: Insufficient permissions")
        return {"error": "Forbidden"}
    elif response.status_code == 404:
        logger.error("Not Found: Resource not found")
        return {"error": "Not Found"}
    elif response.status_code == 500:
        logger.error("Internal Server Error")
        return {"error": "Internal Server Error"}
    else:
        logger.error(f"Unexpected status code: {response.status_code}")
        return {"error": f"Unexpected status code: {response.status_code}"}