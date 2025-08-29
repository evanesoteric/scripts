#!/bin/bash
#
# Laravel permissions

# public
chown -R www-data:www-data public

find ./public -type d -exec chmod 755 {} +
find ./public -type f -exec chmod 644 {} +

# Give the webserver the rights to read and write to storage and cache
chgrp -R www-data storage bootstrap/cache
chmod -R ug+rwx storage bootstrap/cache

# permissions file
chown root:root perm.sh
chmod 700 perm.sh
