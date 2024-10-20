import sys
import importlib.util

# Append the path to where Get_Org_Unit_User_Roles.py is located
module_path = r'path'
module_name = 'Get_Org_Unit_User_Roles'

# Load the module
spec = importlib.util.spec_from_file_location(module_name, module_path)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

# Access the get_org_unit_users function from the module
get_org_unit_users = module.get_org_unit_users

# Example values for testing
org_unit_id = "12345"  # Replace with the actual org unit ID
base_uri = "https://api.example.com"  # Replace with your actual base URI
access_token = "your_access_token_here"  # Replace with your actual access token

# Optional parameters
page_number = 1
page_size = 50
select = None
sort_by = None
sort_order = "ASC"

# Call the get_org_unit_users function
users = get_org_unit_users(org_unit_id, base_uri, access_token, page_number, page_size, select, sort_by, sort_order)

# Print the output
print("Users:", users)
