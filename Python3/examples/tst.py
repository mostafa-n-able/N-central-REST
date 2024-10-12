import sys
sys.path.append('../Users')
from Get_Users_Links import get_users

# Example values for testing
base_uri = "https://api.example.com"
access_token = "YOUR_ACCESS_TOKEN"

user_links = get_users(base_uri, access_token)
print("User links:", user_links)

