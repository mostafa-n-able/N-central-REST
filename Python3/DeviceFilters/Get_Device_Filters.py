def get_device_filters(base_uri, access_token, view_scope=None, page_number=None, page_size=None, select=None, sort_by=None, sort_order=None):
    """
    SYNOPSIS
    Retrieve the list of device filters.

    DESCRIPTION
    This function retrieves the list of filters from N-central for the logged-in user.

    ARGUMENTS
    base_uri (str): The base URI of the API endpoint.
    access_token (str): The access token for authentication.
    view_scope (str, optional): Scope of the filters. Defaults to 'ALL'. Can be 'ALL' or 'OWN_AND_USED'.
    page_number (int, optional): The page number to retrieve. Starts at 1.
    page_size (int, optional): The number of items to retrieve per page.
    select (str, optional): The select expression.
    sort_by (str, optional): The name of a field to sort the result by.
    sort_order (str, optional): The order in which the result will follow. Default is ASC.

    OUTPUTS
    dict: A dictionary containing the list of device filters and pagination information.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library for making HTTP requests.
    - Error handling is implemented for various HTTP status codes.

    USAGE_EXAMPLE
    filters = get_device_filters("https://api.example.com", "your_access_token")
    print(filters)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/device-filters endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/device-filters"

    # Set up headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    # Set up query parameters
    params = {}
    if view_scope:
        params['viewScope'] = view_scope
    if page_number:
        params['pageNumber'] = page_number
    if page_size:
        params['pageSize'] = page_size
    if select:
        params['select'] = select
    if sort_by:
        params['sortBy'] = sort_by
    if sort_order:
        params['sortOrder'] = sort_order

    # Make the API request
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()  # Raise an exception for bad status codes
        
        logger.debug(f"Request URL: {response.url}")
        logger.debug(f"Request Headers: {headers}")
        logger.debug(f"Response Status Code: {response.status_code}")
        logger.debug(f"Response Content: {response.text}")

        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response Status Code: {e.response.status_code}")
            logger.error(f"Response Content: {e.response.text}")
        
        # Handle specific status codes
        if hasattr(e, 'response'):
            if e.response.status_code == 400:
                raise ValueError("Bad Request: Invalid input parameters.")
            elif e.response.status_code == 401:
                raise PermissionError("Unauthorized: Authentication failed.")
            elif e.response.status_code == 403:
                raise PermissionError("Forbidden: Insufficient permissions.")
            elif e.response.status_code == 404:
                raise ValueError("Not Found: The requested resource was not found.")
            elif e.response.status_code == 500:
                raise Exception("Internal Server Error: Something went wrong on the server.")
        
        # If no specific status code handling, re-raise the original exception
        raise