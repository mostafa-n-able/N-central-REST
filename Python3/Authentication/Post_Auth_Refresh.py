import requests
import json
import logging

def refresh_auth_token(base_uri, refresh_token, access_expiry=None, refresh_expiry=None):
    """
    SYNOPSIS
    Refreshes the API access token using a valid refresh token.

    DESCRIPTION
    This function sends a POST request to the /api/auth/refresh endpoint to obtain a new API access token
    using a valid refresh token. It allows optional overrides for access and refresh token expiry times.

    ARGUMENTS
    base_uri (str): The base URI of the API endpoint.
    refresh_token (str): The valid refresh token to use for obtaining a new access token.
    access_expiry (str, optional): Override for access token expiry time. Format: (time)(unit), e.g. "120s" for 120 seconds.
    refresh_expiry (str, optional): Override for refresh token expiry time. Format: (time)(unit), e.g. "120m" for 120 minutes.

    OUTPUTS
    dict: A dictionary containing the refresh response data, including new access and refresh tokens.

    NOTES
    - The function uses the requests library to make HTTP requests.
    - Errors are logged and raised as exceptions.
    - The access and refresh expiry overrides cannot exceed system-wide settings.

    USAGE_EXAMPLE
    base_uri = "https://api.example.com"
    refresh_token = "your_refresh_token_here"
    try:
        response = refresh_auth_token(base_uri, refresh_token, access_expiry="30m", refresh_expiry="12h")
        print(json.dumps(response, indent=2))
    except Exception as e:
        print(f"Error: {str(e)}")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/auth/refresh endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/auth/refresh"

    # Set up headers
    headers = {
        "Content-Type": "text/plain"
    }

    # Add optional expiry override headers
    if access_expiry:
        headers["X-ACCESS-EXPIRY-OVERRIDE"] = access_expiry
    if refresh_expiry:
        headers["X-REFRESH-EXPIRY-OVERRIDE"] = refresh_expiry

    # Log request details
    logger.debug(f"Sending POST request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Refresh token: {refresh_token[:10]}...") # Log only first 10 characters for security

    try:
        # Send POST request
        response = requests.post(url, headers=headers, data=refresh_token)
        
        # Check for successful response
        response.raise_for_status()

        # Parse JSON response
        refresh_data = response.json()

        # Log success
        logger.info("Successfully refreshed auth token")
        logger.debug(f"Response: {json.dumps(refresh_data, indent=2)}")

        return refresh_data

    except requests.exceptions.RequestException as e:
        # Log error details
        logger.error(f"Error refreshing auth token: {str(e)}")
        
        # Handle specific HTTP errors
        if isinstance(e, requests.exceptions.HTTPError):
            status_code = e.response.status_code
            if status_code == 400:
                logger.error("Bad Request: Invalid input or parameters")
            elif status_code == 401:
                logger.error("Unauthorized: Invalid or expired refresh token")
            elif status_code == 403:
                logger.error("Forbidden: Insufficient permissions")
            elif status_code == 500:
                logger.error("Internal Server Error: Something went wrong on the server")
        
        # Re-raise the exception
        raise

    except json.JSONDecodeError as e:
        # Log JSON parsing error
        logger.error(f"Error parsing JSON response: {str(e)}")
        raise

    except Exception as e:
        # Log any other unexpected errors
        logger.error(f"Unexpected error: {str(e)}")
        raise