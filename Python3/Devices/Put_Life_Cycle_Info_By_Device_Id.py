import requests
import json
import logging

def update_device_asset_lifecycle_info(BaseURI, AccessToken, deviceId, assetTag, cost, description, expectedReplacementDate, leaseExpiryDate, location, purchaseDate, warrantyExpiryDate):
    """
    SYNOPSIS
    Updates the asset lifecycle information for a specific device.

    DESCRIPTION
    This function sends a PUT request to update the asset lifecycle information for a device
    identified by its deviceId. It requires various details about the asset lifecycle.

    ARGUMENTS
    BaseURI : string
        The base URI of the API endpoint
    AccessToken : string
        The access token for authentication
    deviceId : string
        The ID of the device to update
    assetTag : string
        The asset tag of the device
    cost : number
        The cost of the device
    description : string
        A description of the device (max 255 characters)
    expectedReplacementDate : string
        The expected replacement date (format: YYYY-MM-DD)
    leaseExpiryDate : string
        The lease expiry date (format: YYYY-MM-DD)
    location : string
        The location of the device
    purchaseDate : string
        The purchase date of the device (format: YYYY-MM-DD)
    warrantyExpiryDate : string
        The warranty expiry date (format: YYYY-MM-DD)

    OUTPUTS
    Returns the response from the API as a JSON object.

    NOTES
    - All date fields should be in the format YYYY-MM-DD.
    - The description field has a maximum length of 255 characters.
    - The 'updateWarrantyError' field is read-only and cannot be modified through this function.

    USAGE_EXAMPLE
    response = update_device_asset_lifecycle_info(
        "https://api.example.com",
        "your_access_token",
        "123456",
        "ASSET-001",
        1000.00,
        "Company laptop",
        "2025-12-31",
        "2024-12-31",
        "Main Office",
        "2023-01-01",
        "2026-12-31"
    )

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/devices/{deviceId}/assets/lifecycle-info endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{BaseURI}/api/devices/{deviceId}/assets/lifecycle-info"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {AccessToken}",
        "Content-Type": "application/json"
    }

    # Prepare the request payload
    payload = {
        "assetTag": assetTag,
        "cost": cost,
        "description": description,
        "expectedReplacementDate": expectedReplacementDate,
        "leaseExpiryDate": leaseExpiryDate,
        "location": location,
        "purchaseDate": purchaseDate,
        "warrantyExpiryDate": warrantyExpiryDate
    }

    # Log the request details
    logger.debug(f"Sending PUT request to: {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Payload: {json.dumps(payload, indent=2)}")

    try:
        # Send the PUT request
        response = requests.put(url, headers=headers, json=payload)
        
        # Check if the request was successful
        response.raise_for_status()
        
        # Log the response
        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response content: {response.text}")
        
        # Return the response as a JSON object
        return response.json()
    
    except requests.exceptions.RequestException as e:
        # Log the error
        logger.error(f"An error occurred: {str(e)}")
        
        # If there's a response, log its content
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        
        # Re-raise the exception
        raise