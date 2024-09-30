import requests
import json
import logging

def post_custom_psa_ticket_info(customPsaTicketId, username, password, BaseURI, AccessToken):
    """
    SYNOPSIS
    Retrieve detailed information for a specific Custom PSA Ticket by ID.

    DESCRIPTION
    This function retrieves detailed information for a specific Custom PSA Ticket using the provided ticket ID.
    It sends a POST request to the /api/custom-psa/tickets/{customPsaTicketId} endpoint.

    ARGUMENTS
    customPsaTicketId : str
        The unique identifier of the Custom PSA ticket to retrieve.
    username : str
        The username for PSA credentials.
    password : str
        The password for PSA credentials.
    BaseURI : str
        The base URI for the API endpoint.
    AccessToken : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the Custom PSA ticket information.

    NOTES
    - This endpoint is currently in a preview stage.
    - This endpoint is exclusive to CUSTOM PSA Integrations, NOT for ConnectWise, AutoTask, TigerPaw or other managed PSAs.

    USAGE_EXAMPLE
    ticket_info = post_custom_psa_ticket_info("12345", "user@example.com", "password123", "https://api.example.com", "access_token_here")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/custom-psa/tickets/{customPsaTicketId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/custom-psa/tickets/{customPsaTicketId}"

    # Prepare the headers
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {AccessToken}"
    }

    # Prepare the request body
    body = {
        "username": username,
        "password": password
    }

    try:
        # Send the POST request
        logger.debug(f"Sending POST request to {url}")
        response = requests.post(url, headers=headers, json=body)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        ticket_info = response.json()
        logger.info("Successfully retrieved Custom PSA ticket information")
        return ticket_info

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while making the request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        raise

    except Exception as e:
        logger.error(f"An unexpected error occurred: {str(e)}")
        raise
