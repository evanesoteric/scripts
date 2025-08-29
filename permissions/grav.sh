#!/bin/bash
#
# Grav permissions

# public
chown -R www-data:www-data public
find ./public -type d -exec chmod 755 {} +
find ./public -type d -exec chmod +s {} +
find ./public -type f -exec chmod 644 {} +

find ./public/bin -type f -exec chmod 775 {} \;

# permissions file
chown root:root perm.sh
chmod 700 perm.sh
