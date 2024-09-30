def get_devices(base_uri, access_token, filter_id=None, page_number=None, page_size=None, select=None, sort_by=None, sort_order=None):
    """
    SYNOPSIS
    Retrieve a list of devices from N-central.

    DESCRIPTION
    This function retrieves a list of devices from N-central using the GET /api/devices endpoint.
    It supports pagination, filtering, sorting, and field selection.

    ARGUMENTS
    base_uri (str): The base URI of the API endpoint.
    access_token (str): The access token for authentication.
    filter_id (int, optional): The ID of the filter to apply for this device list.
    page_number (int, optional): The page number to retrieve. Starts at 1.
    page_size (int, optional): The number of items to retrieve per page.
    select (str, optional): The select expression for field selection.
    sort_by (str, optional): The name of a field to sort the result by.
    sort_order (str, optional): The order in which to sort (asc or desc).

    OUTPUTS
    dict: A JSON object containing the list of devices and pagination information.

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling is implemented for common HTTP status codes.
    - The function uses debug logging to provide additional information during execution.

    USAGE_EXAMPLE
    devices = get_devices(
        base_uri="https://api.example.com",
        access_token="your_access_token",
        page_size=50,
        sort_by="deviceName",
        sort_order="asc"
    )
    print(devices)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices"

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

    # Use the New-HttpQueryString function to create the query string
    query_string = New-HttpQueryString(Parameters=params)

    # Log the request details
    logger.debug(f"Sending GET request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Query parameters: {query_string}")

    try:
        # Send the GET request
        response = requests.get(url, headers=headers, params=query_string)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching devices: {str(e)}")
        
        # Handle specific HTTP status codes
        if response.status_code == 400:
            logger.error("Bad Request: The server cannot process the request due to a client error.")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication has failed or has not been provided.")
        elif response.status_code == 403:
            logger.error("Forbidden: The server understood the request but refuses to authorize it.")
        elif response.status_code == 404:
            logger.error("Not Found: The requested resource could not be found.")
        elif response.status_code == 500:
            logger.error("Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.")
        
        # Return None or raise an exception based on your error handling strategy
        return None