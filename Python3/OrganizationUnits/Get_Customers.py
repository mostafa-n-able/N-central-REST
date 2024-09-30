def get_customers(base_uri, access_token, page_number=None, page_size=None, select=None, sort_by=None, sort_order=None):
    """
    SYNOPSIS
    Retrieve a list of all customers from the N-central API.

    DESCRIPTION
    This function makes a GET request to the /api/customers endpoint of the N-central API
    to retrieve a list of all customers. It supports pagination, sorting, and field selection.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication
    page_number : int, optional
        The page number to retrieve (starts at 1)
    page_size : int, optional
        The number of items to retrieve per page
    select : str, optional
        The select expression for field filtering
    sort_by : str, optional
        The name of the field to sort the result by
    sort_order : str, optional
        The sort order (asc, ascending, natural, desc, descending, reverse)

    OUTPUTS
    dict
        A dictionary containing the list of customers and pagination information

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling is implemented for common HTTP status codes.
    - Debugging information is logged using the 'logging' module.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    result = get_customers(base_uri, access_token, page_size=50, sort_by="customerName", sort_order="asc")
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/customers"

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

    # Log the request details
    logger.debug(f"Making GET request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Query parameters: {params}")

    try:
        # Make the GET request
        response = requests.get(url, headers=headers, params=params)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")

        # Handle specific status codes
        if hasattr(e, 'response'):
            if e.response.status_code == 400:
                logger.error("Bad Request: The server cannot process the request due to a client error.")
            elif e.response.status_code == 401:
                logger.error("Unauthorized: Authentication failed or user doesn't have permissions for requested operation.")
            elif e.response.status_code == 403:
                logger.error("Forbidden: The server understood the request but refuses to authorize it.")
            elif e.response.status_code == 404:
                logger.error("Not Found: The requested resource could not be found.")
            elif e.response.status_code == 500:
                logger.error("Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.")

        # Re-raise the exception for the caller to handle
        raise

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        raise