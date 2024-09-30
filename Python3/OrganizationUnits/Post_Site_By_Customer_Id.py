def create_customer_site(base_uri, access_token, customer_id, site_data):
    """
    .SYNOPSIS
    Creates a new site for a specific customer.

    .DESCRIPTION
    This function creates a new site for a given customer using the N-central API.
    It sends a POST request to the /api/customers/{customerId}/sites endpoint.

    .ARGUMENTS
    base_uri: string
        The base URI of the N-central API.
    access_token: string
        The access token for authentication.
    customer_id: string
        The ID of the customer for which to create the site.
    site_data: dict
        A dictionary containing the site information to be created.

    .OUTPUTS
    dict
        A dictionary containing the created site's ID if successful.

    .NOTES
    This function requires the 'requests' library to be installed.
    Error handling is implemented for common HTTP errors and API-specific errors.

    .USAGE_EXAMPLE
    base_uri = "https://api.ncentral.com"
    access_token = "your_access_token_here"
    customer_id = "123456"
    site_data = {
        "siteName": "New Site",
        "contactFirstName": "John",
        "contactLastName": "Doe",
        "licenseType": "Professional"
    }
    result = create_customer_site(base_uri, access_token, customer_id, site_data)
    print(result)

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/customers/{customerId}/sites endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/customers/{customer_id}/sites"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    try:
        # Send the POST request
        logger.debug(f"Sending POST request to {url}")
        response = requests.post(url, headers=headers, json=site_data)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        result = response.json()
        logger.info("Site created successfully")
        return result

    except requests.exceptions.RequestException as e:
        logger.error(f"HTTP Request failed: {e}")
        if hasattr(e, 'response') and e.response is not None:
            try:
                error_detail = e.response.json()
                logger.error(f"API error response: {error_detail}")
            except ValueError:
                logger.error(f"API error response: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Failed to parse JSON response: {e}")
        raise

    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        raise