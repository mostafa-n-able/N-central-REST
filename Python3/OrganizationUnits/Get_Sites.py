def get_sites(base_uri, access_token, page_number=1, page_size=50, select=None, sort_by=None, sort_order="ASC"):
    """
    SYNOPSIS
    Retrieve a list of all sites from the N-central API.

    DESCRIPTION
    This function makes a GET request to the /api/sites endpoint of the N-central API
    to retrieve a list of all sites. It supports pagination, sorting, and field selection.

    ARGUMENTS
    base_uri (str): The base URI of the API endpoint.
    access_token (str): The access token for authentication.
    page_number (int, optional): The page number to retrieve. Defaults to 1.
    page_size (int, optional): The number of items per page. Defaults to 50.
    select (str, optional): The select expression for field filtering.
    sort_by (str, optional): The field to sort the results by.
    sort_order (str, optional): The sort order (ASC or DESC). Defaults to ASC.

    OUTPUTS
    dict: A JSON object containing the list of sites and pagination information.

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling is implemented for common HTTP errors.
    - The function uses debug logging to provide detailed information about the request and response.

    USAGE_EXAMPLE
    base_uri = "https://api.ncentral.com"
    access_token = "your_access_token_here"
    sites = get_sites(base_uri, access_token, page_size=100, sort_by="siteName")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/sites endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/sites"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    # Set up the query parameters
    params = {
        "pageNumber": page_number,
        "pageSize": page_size
    }

    if select:
        params["select"] = select
    if sort_by:
        params["sortBy"] = sort_by
    if sort_order:
        params["sortOrder"] = sort_order

    # Log the request details
    logger.debug(f"Making GET request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Params: {params}")

    try:
        # Make the GET request
        response = requests.get(url, headers=headers, params=params)

        # Check for HTTP errors
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()

        # Log the response
        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response data: {data}")

        return data

    except requests.exceptions.RequestException as e:
        logger.error(f"An error occurred: {e}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response text: {e.response.text}")
        raise

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        raise