def get_customers_by_service_org(soId, BaseURI, AccessToken, pageNumber=None, pageSize=None, select=None, sortBy=None, sortOrder=None):
    """
    SYNOPSIS
    Retrieve a list of all customers under a service organization.

    DESCRIPTION
    This function retrieves a list of customers associated with a specific service organization
    using the GET /api/service-orgs/{soId}/customers endpoint.

    ARGUMENTS
    soId : int
        The ID of the service organization.
    BaseURI : str
        The base URI for the API endpoint.
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
        The order in which to sort the results (asc or desc).

    OUTPUTS
    dict
        A dictionary containing the list of customers and pagination information.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library for making HTTP requests.
    - Error handling is implemented for various HTTP status codes.

    USAGE_EXAMPLE
    customers = get_customers_by_service_org(123, "https://api.example.com", "your_access_token")
    print(customers)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/service-orgs/{soId}/customers endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/service-orgs/{soId}/customers"

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

    # Log the request details
    logger.debug(f"Making GET request to: {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Params: {params}")

    try:
        # Make the GET request
        response = requests.get(url, headers=headers, params=params)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        # Log the error
        logger.error(f"Error occurred while making the request: {str(e)}")

        # Handle specific HTTP status codes
        if response.status_code == 400:
            logger.error("Bad Request: Invalid input parameters")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication failure")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions")
        elif response.status_code == 404:
            logger.error("Not Found: Service organization not found")
        elif response.status_code == 500:
            logger.error("Internal Server Error")

        # Re-raise the exception
        raise

    except ValueError as e:
        # Log JSON parsing error
        logger.error(f"Error parsing JSON response: {str(e)}")
        raise

    finally:
        # Log the response status code
        if 'response' in locals():
            logger.debug(f"Response status code: {response.status_code}")