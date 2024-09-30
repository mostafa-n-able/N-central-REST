import requests
import json
import logging

def authenticate_user(base_uri, jwt_token, access_expiry=None, refresh_expiry=None):
    """
    SYNOPSIS
    Authenticate a user and obtain access and refresh tokens.

    DESCRIPTION
    This function authenticates a user using the provided JWT token and returns
    access and refresh tokens. It uses the POST /api/auth/authenticate endpoint.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint.
    jwt_token : str
        The N-central User-API Token (JWT) for authentication.
    access_expiry : str, optional
        Override the access-expiry. Format: (time)(unit). E.g., "120s" for 120 seconds.
    refresh_expiry : str, optional
        Override the refresh-expiry. Format: (time)(unit). E.g., "120m" for 120 minutes.

    OUTPUTS
    dict
        A dictionary containing the authentication response, including access and refresh tokens.

    NOTES
    - The function uses the requests library to make HTTP requests.
    - Extensive error handling and logging are implemented.
    - The function adheres to the OpenAPI specification for the authenticate endpoint.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    jwt_token = "your_jwt_token_here"
    result = authenticate_user(base_uri, jwt_token)
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/auth/authenticate endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/auth/authenticate"

    # Set up headers
    headers = {
        "Authorization": f"Bearer {jwt_token}",
        "Content-Type": "application/json"
    }

    # Add optional headers if provided
    if access_expiry:
        headers["X-ACCESS-EXPIRY-OVERRIDE"] = access_expiry
    if refresh_expiry:
        headers["X-REFRESH-EXPIRY-OVERRIDE"] = refresh_expiry

    logger.debug(f"Sending POST request to {url}")
    logger.debug(f"Headers: {headers}")

    try:
        # Send POST request
        response = requests.post(url, headers=headers)
        
        # Check if the request was successful
        response.raise_for_status()

        # Parse and return the JSON response
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while making the request: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        
        # Attempt to parse error response
        try:
            error_data = e.response.json()
            return {"error": error_data.get("message", "Unknown error occurred")}
        except:
            return {"error": str(e)}

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return {"error": "Invalid JSON response from server"}

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        return {"error": "An unexpected error occurred"}
