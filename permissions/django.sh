#!/bin/bash

# SCRIPT TO BE RUN FROM INSIDE /var/www/django_app

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
# 750: User rwx, Group rx, Others ---
# Allows the web server to enter directories.
echo "Setting directory permissions..."
sudo find ${APP_PATH} -type d -exec chmod 750 {} \;

# 3. Set Base Permissions for Files
# 640: User rw, Group r, Others ---
# Allows the web server to read files but not execute them.
echo "Setting file permissions..."
sudo find ${APP_PATH} -type f -exec chmod 640 {} \;

# 4. Grant Execute Permissions to Specific Files
# Make manage.py and this script executable for the user.
echo "Setting execute permissions..."
sudo chmod u+x ${APP_PATH}/manage.py
sudo chmod u+x ${APP_PATH}/perm.sh

# 5. Set Special Write Permissions for Django
# Allow the web server group to write to the database and media upload directory.
echo "Setting special write permissions for Django..."

# For SQLite database (if used)
DB_PATH="${APP_PATH}/db.sqlite3"
if [ -f "$DB_PATH" ]; then
    sudo chmod 660 $DB_PATH
    sudo chmod g+w $(dirname $DB_PATH) # Also make the containing directory group-writable
fi

# For the media directory (user uploads)
MEDIA_PATH="${APP_PATH}/media"
if [ -d "$MEDIA_PATH" ]; then
    sudo find $MEDIA_PATH -type d -exec chmod 770 {} \;
    sudo find $MEDIA_PATH -type f -exec chmod 660 {} \;
fi

echo "Permissions have been set successfully."
