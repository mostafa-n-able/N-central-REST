def get_devices_by_org_unit(org_unit_id, base_uri, access_token, filter_id=None, page_number=None, page_size=None, select=None, sort_by=None, sort_order=None):
    """
    SYNOPSIS
    Retrieve the list of devices by organization unit ID.

    DESCRIPTION
    This function retrieves a list of devices associated with a specific organization unit.
    It uses the GET /api/org-units/{orgUnitId}/devices endpoint.

    ARGUMENTS
    org_unit_id (str): The ID of the organization unit for which to fetch devices.
    base_uri (str): The base URI of the API endpoint.
    access_token (str): The access token for authentication.
    filter_id (int, optional): The ID of the filter to apply for this device list.
    page_number (int, optional): The page number to retrieve (starts at 1).
    page_size (int, optional): The number of items to retrieve per page.
    select (str, optional): The select expression for filtering fields.
    sort_by (str, optional): The name of the field to sort the result by.
    sort_order (str, optional): The order in which to sort (asc or desc).

    OUTPUTS
    dict: A dictionary containing the list of devices and pagination information.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library for making HTTP requests.
    - Error handling is implemented for various HTTP status codes.

    USAGE_EXAMPLE
    devices = get_devices_by_org_unit("12345", "https://api.example.com", "your_access_token")
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/devices"

    # Set up headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    # Set up query parameters
    params = {}
    if filter_id is not None:
        params["filterId"] = filter_id
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
        return None

    # Check the response status code
    if response.status_code == 200:
        logger.info("Successfully retrieved device list")
        return response.json()
    elif response.status_code == 400:
        logger.error("Bad Request: Invalid input parameters")
    elif response.status_code == 401:
        logger.error("Unauthorized: Authentication failure")
    elif response.status_code == 403:
        logger.error("Forbidden: Insufficient permissions")
    elif response.status_code == 404:
        logger.error("Not Found: Resource not found")
    elif response.status_code == 500:
        logger.error("Internal Server Error")
    else:
        logger.error(f"Unexpected status code: {response.status_code}")

    return None

# PROMPT: Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/devices endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.