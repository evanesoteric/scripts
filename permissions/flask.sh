#!/bin/bash

# SCRIPT TO BE RUN FROM INSIDE /var/www/flask_app

# Set the user you log in with (e.g., the user that owns the files)
APP_USER="your_username"

# Set the web server group (usually www-data for Debian/Ubuntu, nginx for RHEL/CentOS)
WEB_GROUP="www-data"

# Get the directory where the script is located
APP_PATH=$(pwd)

# 1. Set Ownership
# Set the user as the owner and the web server group as the group owner.
# This allows you to edit files, and Nginx/Gunicorn to read them.
echo "Setting ownership..."
sudo chown -R ${APP_USER}:${WEB_GROUP} ${APP_PATH}

# 2. Set Base Permissions for Directories
# 750: User can read/write/execute, Group can read/execute, Others have no access.
# This allows the web server to enter directories and list their contents.
echo "Setting directory permissions..."
sudo find ${APP_PATH} -type d -exec chmod 750 {} \;

# 3. Set Base Permissions for Files
# 640: User can read/write, Group can only read, Others have no access.
# This prevents files from being executed by default.
echo "Setting file permissions..."
sudo find ${APP_PATH} -type f -exec chmod 640 {} \;

# 4. Grant Execute Permissions to Specific Files
# Make the main application runner and this script executable for the user.
echo "Setting execute permissions for specific scripts..."
if [ -f "${APP_PATH}/run.py" ]; then
    sudo chmod u+x ${APP_PATH}/run.py
fi
sudo chmod u+x ${APP_PATH}/perm.sh

# 5. Set Special Permissions for Instance/Log folders (if they exist)
# These folders often need to be writable by the web server process.
echo "Setting special write permissions..."
if [ -d "${APP_PATH}/instance" ]; then
    sudo chmod -R g+w ${APP_PATH}/instance
fi
if [ -d "${APP_PATH}/logs" ]; then
    sudo chmod -R g+w ${APP_PATH}/logs
fi

echo "Permissions have been set successfully."
