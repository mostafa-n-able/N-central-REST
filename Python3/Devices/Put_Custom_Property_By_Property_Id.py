def update_device_custom_property(device_id, property_id, value, base_uri, access_token):
    """
    SYNOPSIS
    Update a device custom property

    DESCRIPTION
    This function updates a custom property for a specific device using the 
    PUT /api/devices/{deviceId}/custom-properties/{propertyId} endpoint.

    ARGUMENTS
    device_id : str
        The ID of the device to update the custom property for
    property_id : str
        The ID of the custom property to update
    value : str
        The new value for the custom property
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication

    OUTPUTS
    dict
        A dictionary containing the response from the API, including any warnings

    NOTES
    - This function requires the requests library to be installed
    - Error handling is implemented for common HTTP errors
    - Debugging information is logged using the logging module

    USAGE_EXAMPLE
    response = update_device_custom_property("123456", "789012", "New Value", "https://api.example.com", "your_access_token")
    print(response)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/devices/{deviceId}/custom-properties/{propertyId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}/custom-properties/{property_id}"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Prepare the request body
    body = {
        "value": value
    }

    logger.debug(f"Sending PUT request to {url}")
    logger.debug(f"Request body: {body}")

    try:
        # Send the PUT request
        response = requests.put(url, headers=headers, json=body)
        
        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        result = response.json()

        logger.debug(f"Received response: {result}")

        return result

    except requests.exceptions.RequestException as e:
        logger.error(f"An error occurred: {e}")
        if hasattr(e, 'response') and e.response is not None:
            try:
                error_detail = e.response.json()
                logger.error(f"Error details: {error_detail}")
                return error_detail
            except ValueError:
                logger.error(f"Could not parse error response: {e.response.text}")
                return {"error": str(e), "details": e.response.text}
        else:
            return {"error": str(e)}