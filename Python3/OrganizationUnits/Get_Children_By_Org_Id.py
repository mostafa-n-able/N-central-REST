def get_organization_unit_children(BaseURI, AccessToken, orgUnitId, pageNumber=None, pageSize=None, select=None, sortBy=None, sortOrder=None):
    """
    SYNOPSIS
    Retrieve a list of all organization units children.

    DESCRIPTION
    This function retrieves a list of all organization units under a specific parent organization unit.

    ARGUMENTS
    BaseURI (str): The base URI of the API endpoint.
    AccessToken (str): The access token for authentication.
    orgUnitId (int): The ID of the parent organization unit.
    pageNumber (int, optional): The page number to retrieve. Starts at 1.
    pageSize (int, optional): The number of items to retrieve per page. Set to -1 to retrieve all items.
    select (str, optional): The select expression.
    sortBy (str, optional): The name of a field to sort the result by.
    sortOrder (str, optional): The order in which to sort the results (ASC or DESC).

    OUTPUTS
    dict: A dictionary containing the list of organization unit children and pagination information.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library to make the API call.
    - Error handling is implemented for various HTTP status codes.

    USAGE_EXAMPLE
    children = get_organization_unit_children(BaseURI, AccessToken, 123, pageNumber=1, pageSize=50)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/children endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/org-units/{orgUnitId}/children"

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
            logger.error("Not Found: Resource not found")
        elif response.status_code == 500:
            logger.error("Internal Server Error")
        
        # Re-raise the exception
        raise

    except ValueError as e:
        # Log JSON parsing error
        logger.error(f"Error parsing JSON response: {str(e)}")
        raise

    except Exception as e:
        # Log any other unexpected errors
        logger.error(f"Unexpected error occurred: {str(e)}")
        raise