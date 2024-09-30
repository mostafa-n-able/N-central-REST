def create_service_organization(base_uri, access_token, so_name, contact_first_name, contact_last_name, 
                                city=None, contact_department=None, contact_email=None, contact_phone=None, 
                                contact_phone_ext=None, contact_title=None, country=None, external_id=None, 
                                phone=None, postal_code=None, state_prov=None, street1=None, street2=None):
    """
    SYNOPSIS
    Creates a new service organization using the N-central API.

    DESCRIPTION
    This function sends a POST request to the /api/service-orgs endpoint to create a new service organization
    with the provided details.

    ARGUMENTS
    base_uri : str
        The base URI of the API endpoint
    access_token : str
        The access token for authentication
    so_name : str
        Name of the service organization (required)
    contact_first_name : str
        First name of the contact for the organization unit (required)
    contact_last_name : str
        Last name of the contact for the organization unit (required)
    city : str, optional
        City where the organization unit is located
    contact_department : str, optional
        Department of the contact for the organization unit
    contact_email : str, optional
        Contact email for the organization unit
    contact_phone : str, optional
        Telephone of the contact for the organization unit
    contact_phone_ext : str, optional
        Telephone extension of the contact for the organization unit
    contact_title : str, optional
        Title of the contact for the organization unit
    country : str, optional
        Country where the organization unit is located (two-character country code)
    external_id : str, optional
        The external ID of the organization unit
    phone : str, optional
        Telephone of the contact for the organization unit
    postal_code : str, optional
        Postal code of the organization unit location
    state_prov : str, optional
        State or province where the organization unit is located
    street1 : str, optional
        First line of street address for the organization unit
    street2 : str, optional
        Second line of street address for the organization unit

    OUTPUTS
    dict
        A dictionary containing the created service organization's ID

    NOTES
    - This endpoint is currently in a preview stage.
    - Ensure that you have the necessary permissions to create service organizations.
    - The function uses the requests library for making HTTP requests.

    USAGE_EXAMPLE
    base_uri = "https://api.ncentral.com"
    access_token = "your_access_token_here"
    new_so = create_service_organization(base_uri, access_token, "New SO Name", "John", "Doe", 
                                         city="New York", contact_email="john.doe@example.com")
    print(f"Created new service organization with ID: {new_so['soId']}")

    PROMPT
    Read the OpenAPI Spec and using the details and parameters for the POST /api/service-orgs endpoint, 
    write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/service-orgs"

    # Prepare the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Prepare the payload
    payload = {
        "soName": so_name,
        "contactFirstName": contact_first_name,
        "contactLastName": contact_last_name
    }

    # Add optional parameters if they are provided
    optional_params = {
        "city": city,
        "contactDepartment": contact_department,
        "contactEmail": contact_email,
        "contactPhone": contact_phone,
        "contactPhoneExt": contact_phone_ext,
        "contactTitle": contact_title,
        "country": country,
        "externalId": external_id,
        "phone": phone,
        "postalCode": postal_code,
        "stateProv": state_prov,
        "street1": street1,
        "street2": street2
    }

    for key, value in optional_params.items():
        if value is not None:
            payload[key] = value

    logger.debug(f"Sending POST request to {url}")
    logger.debug(f"Headers: {headers}")
    logger.debug(f"Payload: {json.dumps(payload, indent=2)}")

    try:
        # Send the POST request
        response = requests.post(url, headers=headers, json=payload)
        
        # Check if the request was successful
        response.raise_for_status()
        
        # Parse the JSON response
        result = response.json()
        
        logger.info(f"Successfully created service organization with ID: {result['data']['soId']}")
        return result['data']

    except requests.exceptions.RequestException as e:
        logger.error(f"Error creating service organization: {str(e)}")
        if hasattr(e, 'response') and e.response is not None:
            logger.error(f"Response status code: {e.response.status_code}")
            logger.error(f"Response content: {e.response.text}")
        raise

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        raise

    except KeyError as e:
        logger.error(f"Expected key not found in the response: {str(e)}")
        raise