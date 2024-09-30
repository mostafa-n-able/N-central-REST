def update_org_unit_custom_property_defaults(org_unit_id, property_data, base_uri, access_token):
    """
    SYNOPSIS
    Update the default organization unit custom property for the given organization unit id.

    DESCRIPTION
    This function updates the default custom property for an organization unit using the 
    PUT /api/org-units/{orgUnitId}/org-custom-property-defaults endpoint.

    ARGUMENTS
    org_unit_id : int
        The ID of the organization unit.
    property_data : dict
        A dictionary containing the custom property data to update. It should include:
        - defaultValue (optional): The default value of the property.
        - enumeratedValueList (optional): List of allowed values for ENUMERATED property type.
        - propagate (optional): Boolean flag to specify whether to propagate changes.
        - propagationType: The way property value changes are propagated.
        - propertyId: The ID of the property to update.
        - propertyName: The name of the property.
        - selectedOrgUnitIds: List of org unit IDs where the property is applicable.
    base_uri : str
        The base URI of the API endpoint.
    access_token : str
        The access token for authentication.

    OUTPUTS
    dict
        A dictionary containing the API response.

    NOTES
    - This function requires the 'requests' library to be installed.
    - Error handling for network issues and API errors is implemented.

    USAGE_EXAMPLE
    property_data = {
        "defaultValue": "http://www.example.com",
        "propagate": False,
        "propagationType": "SITE_ONLY",
        "propertyId": 186156786,
        "propertyName": "Prop Name 1",
        "selectedOrgUnitIds": [209, 210]
    }
    result = update_org_unit_custom_property_defaults(209, property_data, "https://api.example.com", "your_access_token")
    print(result)

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the PUT /api/org-units/{orgUnitId}/org-custom-property-defaults endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/org-custom-property-defaults"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Log the request details
    logger.debug(f"Sending PUT request to {url}")
    logger.debug(f"Request headers: {headers}")
    logger.debug(f"Request body: {property_data}")

    try:
        # Send the PUT request
        response = requests.put(url, json=property_data, headers=headers)
        
        # Check if the request was successful
        response.raise_for_status()

        # Log the response
        logger.debug(f"Response status code: {response.status_code}")
        logger.debug(f"Response body: {response.text}")

        # If the response is successful but empty (as expected for a 204 No Content)
        if response.status_code == 204:
            return {"message": "Custom property updated successfully"}
        
        # If there's content in the response, parse and return it
        return response.json()

    except requests.exceptions.RequestException as e:
        # Log the error
        logger.error(f"An error occurred: {str(e)}")

        # Handle specific HTTP errors
        if isinstance(e, requests.exceptions.HTTPError):
            status_code = e.response.status_code
            if status_code == 400:
                return {"error": "Bad Request", "message": "Invalid organization unit id or property id."}
            elif status_code == 401:
                return {"error": "Unauthorized", "message": "Authentication failure."}
            elif status_code == 403:
                return {"error": "Forbidden", "message": "You don't have permission to access this resource."}
            elif status_code == 404:
                return {"error": "Not Found", "message": "Custom Property not found."}
            elif status_code == 500:
                return {"error": "Internal Server Error", "message": "An unexpected error occurred on the server."}
        
        # For other types of request exceptions
        return {"error": "Request Failed", "message": str(e)}