def get_device_by_id(device_id, base_uri, access_token):
    """
    .SYNOPSIS
    Retrieve a device by ID.

    .DESCRIPTION
    This function retrieves detailed information about a specific device using its ID.

    .ARGUMENTS
    device_id : str
        The ID of the device for which information needs to be fetched.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token needed for authentication.

    .OUTPUTS
    dict
        A dictionary containing the device information.

    .NOTES
    This function requires the 'requests' library to be installed.

    .USAGE_EXAMPLE
    device_info = get_device_by_id("123456", "https://api.example.com", "your_access_token_here")

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/devices/{deviceId} endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json

    # Construct the full URL
    url = f"{base_uri}/api/devices/{device_id}"

    # Set up the headers with the access token
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        device_info = response.json()

        # Debug logging
        print(f"DEBUG: Successfully retrieved device information for device ID: {device_id}")

        return device_info

    except requests.exceptions.RequestException as e:
        # Handle any errors that occurred during the request
        print(f"ERROR: An error occurred while fetching device information: {str(e)}")
        
        # If we got a response, try to parse it for more information
        if hasattr(e, 'response') and e.response is not None:
            try:
                error_info = e.response.json()
                print(f"DEBUG: Error response: {json.dumps(error_info, indent=2)}")
            except json.JSONDecodeError:
                print(f"DEBUG: Error response (non-JSON): {e.response.text}")
        
        return None

    except json.JSONDecodeError as e:
        # Handle JSON parsing errors
        print(f"ERROR: Failed to parse the response as JSON: {str(e)}")
        return None

    except Exception as e:
        # Handle any other unexpected errors
        print(f"ERROR: An unexpected error occurred: {str(e)}")
        return None