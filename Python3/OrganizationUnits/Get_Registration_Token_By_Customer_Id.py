def get_customer_registration_token(customerId, BaseURI, AccessToken):
    """
    SYNOPSIS
    Get the registration token for a specific customer.

    DESCRIPTION
    This function retrieves the registration token for a given customer using the N-able N-central API.

    ARGUMENTS
    customerId : int
        The ID of the customer for which to retrieve the registration token.
    BaseURI : str
        The base URL of the API endpoint.
    AccessToken : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the registration token information.

    NOTES
    - This endpoint is currently in a preview stage.
    - Requires a valid access token for authentication.
    - The function uses the requests library for making HTTP requests.

    USAGE_EXAMPLE
    token_info = get_customer_registration_token(12345, "https://api.ncentral.com", "your_access_token")
    print(token_info)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers/{customerId}/registration-token endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/customers/{customerId}/registration-token"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        token_info = response.json()

        logger.info("Successfully retrieved customer registration token")
        return token_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching customer registration token: {str(e)}")
        
        if response.status_code == 400:
            logger.error("Bad Request: Invalid customerId format or other input error")
        elif response.status_code == 401:
            logger.error("Authentication Failure: Invalid or expired access token")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions to access this resource")
        elif response.status_code == 404:
            logger.error(f"Customer with ID {customerId} not found")
        elif response.status_code == 500:
            logger.error("Internal Server Error occurred")
        
        return None

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"An unexpected error occurred: {str(e)}")
        return None