def get_service_organizations(base_uri, access_token, page_number=None, page_size=None, select=None, sort_by=None, sort_order=None):
    """
    SYNOPSIS
    Retrieve a list of all service organizations.

    DESCRIPTION
    This function retrieves a list of all service organizations from the N-central API.
    It supports pagination, sorting, and field selection.

    ARGUMENTS
    base_uri (str): The base URI of the API endpoint
    access_token (str): The access token for authentication
    page_number (int, optional): The page number to retrieve (starts at 1)
    page_size (int, optional): The number of items to retrieve per page
    select (str, optional): The select expression for field filtering
    sort_by (str, optional): The name of the field to sort the result by
    sort_order (str, optional): The sort order (asc, ascending, natural, desc, descending, reverse)

    OUTPUTS
    dict: A dictionary containing the list of service organizations and pagination information

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling for network issues and API errors is implemented.
    - Debugging information is logged using the 'logging' module.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    result = get_service_organizations(base_uri, access_token, page_size=10, sort_by="soName")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/service-orgs endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/service-orgs"

    # Set up headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    # Set up query parameters
    params = {}
    if page_number is not None:
        params['pageNumber'] = page_number
    if page_size is not None:
        params['pageSize'] = page_size
    if select is not None:
        params['select'] = select
    if sort_by is not None:
        params['sortBy'] = sort_by
    if sort_order is not None:
        params['sortOrder'] = sort_order

    # Make the API request
    try:
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()  # Raise an exception for 4xx and 5xx status codes
    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        return {"error": str(e)}

    # Parse the JSON response
    try:
        data = response.json()
        logger.debug(f"Received response: {data}")
        return data
    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        return {"error": "Invalid JSON response"}

    # Note: The function will return None if it reaches this point without returning data or an error