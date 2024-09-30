def get_org_unit_job_statuses(org_unit_id, base_uri, access_token):
    """
    .SYNOPSIS
    Retrieves job statuses for a given organization unit.

    .DESCRIPTION
    This function fetches a list of job statuses for the specified organization unit using the GET /api/org-units/{orgUnitId}/job-statuses endpoint.

    .ARGUMENTS
    org_unit_id - The ID of the organization unit to fetch job statuses for.
    base_uri - The base URI of the API endpoint.
    access_token - The access token for authentication.

    .OUTPUTS
    Returns a JSON object containing the list of job statuses.

    .NOTES
    This endpoint is currently in a preview stage.

    .USAGE_EXAMPLE
    job_statuses = get_org_unit_job_statuses("12345", "https://api.example.com", "your_access_token")

    .PROMPT
    Read the OpenAPI Spec and using the details and parameters for the GET /api/org-units/{orgUnitId}/job-statuses endpoint, write a helper function that would accept those parameters as arguments and returns the output as a JSON object.
    """
    import requests
    import json
    import logging

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    # Construct the full URL
    url = f"{base_uri}/api/org-units/{org_unit_id}/job-statuses"

    # Set up the headers
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Accept": "application/json"
    }

    try:
        # Make the GET request
        logger.debug(f"Making GET request to {url}")
        response = requests.get(url, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the JSON response
        job_statuses = response.json()
        logger.debug(f"Successfully retrieved job statuses for org unit {org_unit_id}")

        return job_statuses

    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while fetching job statuses: {str(e)}")
        if response is not None:
            logger.error(f"Response status code: {response.status_code}")
            logger.error(f"Response content: {response.text}")
        
        # Attempt to parse the error response
        try:
            error_data = response.json()
            return error_data
        except json.JSONDecodeError:
            return {"error": str(e)}

    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON response: {str(e)}")
        return {"error": "Failed to decode JSON response"}

    except Exception as e:
        logger.error(f"Unexpected error occurred: {str(e)}")
        return {"error": "An unexpected error occurred"}