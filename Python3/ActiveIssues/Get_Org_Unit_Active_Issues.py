def get_active_issues(BaseURI, AccessToken, orgUnitId, pageNumber=1, pageSize=50, select=None, sortBy=None, sortOrder="ASC"):
    """
    SYNOPSIS
    Retrieve active issues for a given organization unit.

    DESCRIPTION
    This function fetches a list of active issues for the specified organization unit using the GET /api/org-units/{orgUnitId}/active-issues endpoint.

    ARGUMENTS
    BaseURI : str
        The base URI of the API endpoint
    AccessToken : str
        The access token for authentication
    orgUnitId : str
        ID of the organization unit for which active issues need to be fetched
    pageNumber : int, optional
        The page number to retrieve (default is 1)
    pageSize : int, optional
        The number of items to retrieve per page (default is 50)
    select : str, optional
        The select expression for filtering results
    sortBy : str, optional
        The name of a field to sort the result by
    sortOrder : str, optional
        The order in which the result will follow (default is "ASC")

    OUTPUTS
    dict
        A JSON object containing the list of active issues and pagination information

    NOTES
    - This endpoint is currently in a preview stage.
    - Only organization units that are customers or sites are currently supported.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token"
    org_unit_id = "12345"
    result = get_active_issues(base_uri, access_token, org_unit_id)
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/active-issues endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/org-units/{orgUnitId}/active-issues"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Content-Type": "application/json"
    }

    # Set up the query parameters
    params = {
        "pageNumber": pageNumber,
        "pageSize": pageSize
    }

    # Add optional parameters if provided
    if select:
        params["select"] = select
    if sortBy:
        params["sortBy"] = sortBy
    if sortOrder:
        params["sortOrder"] = sortOrder

    # Use the New-HttpQueryString function to create the query string
    query_string = New-HttpQueryString(Parameters=params)

    # Log the request details
    logger.debug(f"Sending GET request to: {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Query parameters: {query_string}")

    try:
        # Send the GET request
        response = requests.get(url, headers=headers, params=query_string)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()

        # Log the successful response
        logger.debug("Request successful. Received data:")
        logger.debug(data)

        return data

    except requests.exceptions.RequestException as e:
        # Log the error
        logger.error(f"An error occurred: {str(e)}")

        # Handle specific HTTP errors
        if isinstance(e, requests.exceptions.HTTPError):
            status_code = e.response.status_code
            if status_code == 400:
                logger.error("Bad Request: Invalid input format.")
            elif status_code == 401:
                logger.error("Unauthorized: Authentication failure.")
            elif status_code == 403:
                logger.error("Forbidden: You don't have permission to access this resource.")
            elif status_code == 404:
                logger.error("Not Found: The requested resource was not found.")
            elif status_code == 500:
                logger.error("Internal Server Error: Something went wrong on the server side.")
            else:
                logger.error(f"HTTP Error {status_code}: {e.response.text}")
        else:
            logger.error("An unexpected error occurred.")

        # Return None or raise an exception based on your error handling strategy
        return None