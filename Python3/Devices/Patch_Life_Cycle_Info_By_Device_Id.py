def patch_device_asset_lifecycle_info(device_id, asset_lifecycle_info, base_uri, access_token):
    """
    SYNOPSIS
        Modifies the Asset Lifecycle Information for a device with a specific id.

    DESCRIPTION
        This function sends a PATCH request to modify the Asset Lifecycle Information
        for a device identified by its device ID.

    ARGUMENTS
        device_id (str): The ID of the device to modify.
        asset_lifecycle_info (dict): A dictionary containing the asset lifecycle information to update.
        base_uri (str): The base URI of the API endpoint.
        access_token (str): The access token for authentication.

    OUTPUTS
        dict: The response from the API, typically empty for a successful PATCH request.

    NOTES
        - The updateWarrantyError field is read-only and cannot be modified.
        - All date fields should be in the format "YYYY-MM-DD".
        - Ensure that the access token is valid before making the request.

    USAGE_EXAMPLE
        asset_info = {
            "assetTag": "NEW-ASSET-TAG",
            "purchaseDate": "2023-01-01",
            "warrantyExpiryDate": "2026-01-01"
        }
        response = patch_device_asset_lifecycle_info("123456", asset_info, "https://api.example.com", "your_access_token")

    PROMPT
        Read the OpenAPI Spec and using the details and parameters for the PATCH /api/devices/{deviceId}/assets/lifecycle-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}/assets/lifecycle-info"

    # Set up the headers
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    }

    # Log the request details
    logger.debug(f"Sending PATCH request to: {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Payload: {json.dumps(asset_lifecycle_info, indent=2)}")

    try:
        # Send the PATCH request
        response = requests.patch(url, headers=headers, json=asset_lifecycle_info)

        # Check if the request was successful
        response.raise_for_status()

        # Log the response
        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response body: {response.text}")

        # Return the response as a JSON object
        # Note: For a successful PATCH request, the response body might be empty
        return response.json() if response.text else {}

    except requests.exceptions.RequestException as e:
        # Log the error
        logger.error(f"An error occurred: {str(e)}")
        
        # If there's a response from the server, log it
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Server response: {e.response.text}")

        # Re-raise the exception
        raise

    except json.JSONDecodeError as e:
        # Log the error if the response is not valid JSON
        logger.error(f"Failed to decode JSON response: {str(e)}")
        raise

    except Exception as e:
        # Log any other unexpected errors
        logger.error(f"An unexpected error occurred: {str(e)}")
        raise