#!/bin/bash
#
# Permissions

# public
chown -R www-data:www-data public
find ./public -type d -exec chmod 755 {} +
find ./public -type f -exec chmod 644 {} +
find ./public -maxdepth 1 -name wp-config.php -exec chmod 644 {} \;
find ./public -maxdepth 1 -name wp-config-sample.php -delete
find ./public -maxdepth 1 -name readme.html -delete
find ./public -maxdepth 1 -name license.txt -delete

# permissions file
chown root:root perm.sh
chmod 700 perm.sh
