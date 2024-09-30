def get_customer(customerId, BaseURI, AccessToken):
    """
    .SYNOPSIS
    Retrieves a customer by ID.

    .DESCRIPTION
    This function makes a GET request to the /api/customers/{customerId} endpoint
    to retrieve details of a specific customer.

    .ARGUMENTS
    customerId - The ID of the customer to retrieve.
    BaseURI - The base URI of the API endpoint.
    AccessToken - The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the customer details.

    .NOTES
    This endpoint is currently in a preview stage.

    .USAGE_EXAMPLE
    customer = get_customer(123, "https://api.example.com", "your_access_token")

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/customers/{customerId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/customers/{customerId}"

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
        customer_data = response.json()
        logger.info(f"Successfully retrieved customer data for ID: {customerId}")
        return customer_data

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching customer data: {str(e)}")
        if response.status_code == 400:
            logger.error("Bad Request: Invalid customerId format or other input error")
        elif response.status_code == 401:
            logger.error("Unauthorized: Authentication failure")
        elif response.status_code == 403:
            logger.error("Forbidden: Insufficient permissions")
        elif response.status_code == 404:
            logger.error(f"Customer with ID {customerId} not found")
        elif response.status_code == 500:
            logger.error("Internal Server Error occurred")
        else:
            logger.error(f"Unexpected status code: {response.status_code}")
        return None

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return None

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        return None