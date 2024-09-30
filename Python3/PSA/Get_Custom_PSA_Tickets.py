def get_custom_psa_tickets(base_uri, access_token):
    """
    SYNOPSIS
    Retrieve a list of Custom PSA tickets.

    DESCRIPTION
    This function retrieves a list of Custom PSA tickets using the GET /api/custom-psa/tickets endpoint.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication

    OUTPUTS
    dict
        A dictionary containing the response data, including links to related endpoints

    NOTES
    - This endpoint is currently in a preview stage.
    - The function uses the requests library to make the API call.
    - Error handling is implemented to catch and report any issues with the API request.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    access_token = "your_access_token_here"
    result = get_custom_psa_tickets(base_uri, access_token)
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/custom-psa/tickets endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/custom-psa/tickets"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()
        logger.debug("Successfully retrieved Custom PSA tickets")
        return data

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching Custom PSA tickets: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response body: {e.response.text}")
        raise

    except ValueError as e:
        logger.error(f"Error parsing JSON response: {str(e)}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        raise