"""
All Devices History Script

This script retrieves all devices from N-central via the REST API and stores them
in a local SQLite database (ncentral_device_history.db) for historical tracking.

Key Features:
- Authenticates with N-central using a JWT token to obtain an access token
- Retrieves device information using the GET /api/devices endpoint
- Stores device data in SQLite with a 'date' column for each run
- On each run, wipes and repopulates data for the current date only
- Preserves historical data from previous days, building a history over time

Usage:
- Update base_uri and jwt_token with your N-central server URL and API token
- Run the script daily (e.g., via cron) to build historical device records
- Query the SQLite database to analyze device changes over time
"""

import sys
import sqlite3
import os
from datetime import date

# Add the parent directory to the path (relative to this script's location)
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)

from Devices.Get_Devices import get_devices
from Authentication.Post_auth_authenticate import authenticate_user


# Hardcoded schema for the devices table
DEVICES_TABLE_SCHEMA = '''
CREATE TABLE devices (
    date TEXT NOT NULL,
    "applianceId" INTEGER,
    "customerId" INTEGER,
    "customerName" TEXT,
    "description" TEXT,
    "deviceClass" TEXT,
    "deviceClassLabel" TEXT,
    "deviceId" INTEGER,
    "discoveredName" TEXT,
    "isProbe" INTEGER,
    "lastApplianceCheckinTime" TEXT,
    "lastLoggedInUser" TEXT,
    "licenseMode" TEXT,
    "longName" TEXT,
    "orgUnitId" INTEGER,
    "osId" TEXT,
    "remoteControlUri" TEXT,
    "siteId" INTEGER,
    "siteName" TEXT,
    "soId" INTEGER,
    "soName" TEXT,
    "sourceUri" TEXT,
    "stillLoggedIn" TEXT,
    "supportedOs" TEXT,
    "supportedOsLabel" TEXT,
    "uri" TEXT
)
'''

# Column names in order (excluding date)
DEVICE_COLUMNS = [
    "applianceId", "customerId", "customerName", "description", "deviceClass",
    "deviceClassLabel", "deviceId", "discoveredName", "isProbe",
    "lastApplianceCheckinTime", "lastLoggedInUser", "licenseMode", "longName",
    "orgUnitId", "osId", "remoteControlUri", "siteId", "siteName", "soId",
    "soName", "sourceUri", "stillLoggedIn", "supportedOs", "supportedOsLabel", "uri"
]


def save_devices_to_db(db_path, devices):
    """Save devices to SQLite database with date tracking."""
    today = date.today().isoformat()
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Create table if it doesn't exist
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='devices'")
        if not cursor.fetchone():
            cursor.execute(DEVICES_TABLE_SCHEMA)
            print("Created table 'devices'")
        
        # Delete existing records for today's date
        cursor.execute("DELETE FROM devices WHERE date = ?", (today,))
        deleted_count = cursor.rowcount
        if deleted_count > 0:
            print(f"Removed {deleted_count} existing records for {today}")
        
        # Insert new records
        placeholders = ", ".join(["?" for _ in range(len(DEVICE_COLUMNS) + 1)])
        column_names = ", ".join(['"date"'] + [f'"{c}"' for c in DEVICE_COLUMNS])
        insert_sql = f"INSERT INTO devices ({column_names}) VALUES ({placeholders})"
        
        for device in devices:
            values = [today] + [device.get(col) for col in DEVICE_COLUMNS]
            cursor.execute(insert_sql, values)
        
        conn.commit()
        print(f"Successfully saved {len(devices)} devices to database for {today}")
        
        # Show summary of historical data
        cursor.execute("SELECT date, COUNT(*) FROM devices GROUP BY date ORDER BY date")
        history = cursor.fetchall()
        print("\nDatabase history:")
        for record_date, count in history:
            print(f"  {record_date}: {count} devices")
        
    finally:
        conn.close()


# Define the variables needed for authentication
base_uri = "https://yourdomain.com"  # Replace with your N-central server URL
jwt_token = "your_jwt_token"  # Replace with your N-central User-API Token (JWT)

# Optional authentication parameters
access_expiry = None  # Override access token expiry (e.g., "120s" for 120 seconds)
refresh_expiry = None  # Override refresh token expiry (e.g., "120m" for 120 minutes)

# Authenticate and get access token
auth_response = authenticate_user(
    base_uri=base_uri,
    jwt_token=jwt_token,
    access_expiry=access_expiry,
    refresh_expiry=refresh_expiry
)

if not auth_response or "tokens" not in auth_response:
    print("Authentication failed. Please check your credentials.")
    sys.exit(1)

access_token = auth_response["tokens"]["access"]["token"]
print("Successfully authenticated!")

# Optional parameters for get_devices (set to None if not needed)
filter_id = None  # The ID of a filter to apply
page_size = 500  # Number of devices per page
select = None  # Field selection expression
sort_by = "deviceName"  # Sort by device name
sort_order = "asc"  # Sort in ascending order

# Fetch all devices with pagination
all_devices = []
page_number = 1

print("Fetching devices...")
while True:
    response = get_devices(
        base_uri=base_uri,
        access_token=access_token,
        filter_id=filter_id,
        page_number=page_number,
        page_size=page_size,
        select=select,
        sort_by=sort_by,
        sort_order=sort_order
    )
    
    if not response or "data" not in response:
        print(f"Failed to retrieve devices on page {page_number}.")
        break
    
    devices = response["data"]
    if not devices:
        break  # No more devices to fetch
    
    all_devices.extend(devices)
    print(f"  Page {page_number}: fetched {len(devices)} devices (total: {len(all_devices)})")
    
    # Check if we've fetched all devices (less than page_size means last page)
    if len(devices) < page_size:
        break
    
    page_number += 1

# Save results to SQLite database
db_filename = os.path.join(script_dir, "ncentral_device_history.db")

if all_devices:
    save_devices_to_db(db_filename, all_devices)
else:
    print("No devices found.")
