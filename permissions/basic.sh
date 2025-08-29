#!/bin/bash
#
# Permissions

# public
chown -R www-data:www-data public
find ./public -type d -exec chmod 755 {} +
find ./public -type f -exec chmod 644 {} +

# permissions file
chown root:root perm.sh
chmod 700 perm.sh

