def get_customer_sites(customerId, BaseURI, AccessToken, pageNumber=None, pageSize=None, select=None, sortBy=None, sortOrder=None):
    """
    SYNOPSIS
    Retrieve a list of sites under a customer.

    DESCRIPTION
    This function retrieves a list of all sites under a specified customer using the N-central API.

    ARGUMENTS
    customerId : int
        The ID of the customer for which to retrieve sites.
    BaseURI : str
        The base URL of the API endpoint.
    AccessToken : str
        The access token for authentication.
    pageNumber : int, optional
        The page number to retrieve. Starts at 1.
    pageSize : int, optional
        The number of items to retrieve per page.
    select : str, optional
        The select expression for filtering results.
    sortBy : str, optional
        The name of a field to sort the result by.
    sortOrder : str, optional
        The order in which to sort the results (asc, ascending, natural, desc, descending, reverse).

    OUTPUTS
    dict
        A dictionary containing the list of sites and pagination information.

    NOTES
    This endpoint is currently in a preview stage.

    USAGE_EXAMPLE
    sites = get_customer_sites(100, "https://api.example.com", "your_access_token")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers/{customerId}/sites endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/customers/{customerId}/sites"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    # Set up the query parameters
    params = {}
    if pageNumber is not None:
        params['pageNumber'] = pageNumber
    if pageSize is not None:
        params['pageSize'] = pageSize
    if select is not None:
        params['select'] = select
    if sortBy is not None:
        params['sortBy'] = sortBy
    if sortOrder is not None:
        params['sortOrder'] = sortOrder

    # Make the API request
    try:
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()  # Raise an exception for bad status codes
    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        return None

    # Parse the JSON response
    try:
        data = response.json()
        logger.debug(f"Received response: {json.dumps(data, indent=2)}")
        return data
    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {e}")
        return None