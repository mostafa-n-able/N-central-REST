def create_customer(soId, customer_data, BaseURI, AccessToken):
    """
    SYNOPSIS
        Create a new customer under a specified service organization.
    
    DESCRIPTION
        This function creates a new customer with the specified details under a given service organization.
    
    ARGUMENTS
        soId: string
            The ID of the service organization under which to create the customer.
        customer_data: dict
            A dictionary containing the customer details. Required fields:
            - customerName: string
            - contactFirstName: string
            - contactLastName: string
        BaseURI: string
            The base URI for the API endpoint.
        AccessToken: string
            The access token for authentication.
    
    OUTPUTS
        Returns a dictionary containing the created customer's details if successful.
    
    NOTES
        This endpoint is currently in a preview stage.
    
    USAGE_EXAMPLE
        customer_data = {
            "customerName": "New Customer Name",
            "contactFirstName": "John",
            "contactLastName": "Doe",
            "city": "New York",
            "country": "US"
        }
        result = create_customer("12345", customer_data, "https://api.example.com", "your_access_token")
    
    PROMPT
        Read the OpenAPI Spec and using the details and parameters for the POST /api/service-orgs/{soId}/customers endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/service-orgs/{soId}/customers"

    # Set up the headers
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {AccessToken}"
    }

    # Validate required fields
    required_fields = ["customerName", "contactFirstName", "contactLastName"]
    for field in required_fields:
        if field not in customer_data:
            raise ValueError(f"Missing required field: {field}")

    try:
        # Make the POST request
        logger.debug(f"Sending POST request to {url}")
        response = requests.post(url, headers=headers, json=customer_data)

        # Check for successful response
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error creating customer: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        raise

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise