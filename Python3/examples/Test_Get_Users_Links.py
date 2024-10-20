import sys
import importlib.util

# Full path to the Get_Users_Links.py file
module_path = r'path'
module_name = 'Get_Users_Links'

# Load the module
spec = importlib.util.spec_from_file_location(module_name, module_path)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

# Access the get_users function from the module
get_users = module.get_users

# Example values for testing
base_uri = "https://api.example.com"
access_token = "your_access_token_here"

# Call the function and print the result
user_links = get_users(base_uri, access_token)
print("User links:", user_links)