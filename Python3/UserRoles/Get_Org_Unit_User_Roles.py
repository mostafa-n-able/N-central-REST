def get_user_roles(BaseURI, AccessToken, orgUnitId, pageNumber=None, pageSize=None, select=None, sortBy=None, sortOrder=None):
    """
    SYNOPSIS
    Retrieve a list of user roles for a given organization unit.

    DESCRIPTION
    This function retrieves a list of user roles for a specified organization unit using the GET /api/org-units/{orgUnitId}/user-roles endpoint.

    ARGUMENTS
    BaseURI (str): The base URI of the API endpoint.
    AccessToken (str): The access token for authentication.
    orgUnitId (str): The ID of the organization unit for which to retrieve user roles.
    pageNumber (int, optional): The page number to retrieve. Starts at 1.
    pageSize (int, optional): The number of items to retrieve per page.
    select (str, optional): The select expression for filtering results.
    sortBy (str, optional): The name of a field to sort the result by.
    sortOrder (str, optional): The order in which the result will follow (asc, desc, etc.).

    OUTPUTS
    dict: A JSON object containing the list of user roles and pagination information.

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library for making HTTP requests.
    - Error handling is implemented for various HTTP status codes.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    org_unit_id = "12345"
    user_roles = get_user_roles(base_uri, access_token, org_unit_id, pageSize=10, sortBy="roleName")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/user-roles endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/org-units/{orgUnitId}/user-roles"

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
        response.raise_for_status()  # Raise an exception for 4xx and 5xx status codes
    except requests.exceptions.RequestException as e:
        logger.error(f"Error making request: {e}")
        return None

    # Check the response status code
    if response.status_code == 200:
        logger.info("Successfully retrieved user roles")
        return response.json()
    elif response.status_code == 400:
        logger.error("Bad request: Invalid input parameters")
    elif response.status_code == 401:
        logger.error("Authentication failure: Invalid or missing access token")
    elif response.status_code == 403:
        logger.error("Forbidden: Insufficient permissions")
    elif response.status_code == 404:
        logger.error("Not found: The specified organization unit was not found")
    elif response.status_code == 500:
        logger.error("Internal server error")
    else:
        logger.error(f"Unexpected status code: {response.status_code}")

    return None