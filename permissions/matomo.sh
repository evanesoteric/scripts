#!/bin/bash
#
# Permissions

chown -R www-data:www-data matomo
find ./matomo -type d -exec chmod 755 {} +
find ./matomo -type f -exec chmod 644 {} +
find ./matomo/tmp -type f -exec chmod 644 {} \;
find ./matomo/tmp -type d -exec chmod 755 {} \;
find ./matomo/tmp/assets/ -type f -exec chmod 644 {} \;
find ./matomo/tmp/assets/ -type d -exec chmod 755 {} \;
find ./matomo/tmp/cache/ -type f -exec chmod 644 {} \;
find ./matomo/tmp/cache/ -type d -exec chmod 755 {} \;
find ./matomo/tmp/logs/ -type f -exec chmod 644 {} \;
find ./matomo/tmp/logs/ -type d -exec chmod 755 {} \;
find ./matomo/tmp/tcpdf/ -type f -exec chmod 644 {} \;
find ./matomo/tmp/tcpdf/ -type d -exec chmod 755 {} \;
find ./matomo/tmp/templates_c/ -type f -exec chmod 644 {} \;
find ./matomo/tmp/templates_c/ -type d -exec chmod 755 {} \;

# permissions file
chown root:root perm.sh
chmod 700 perm.sh
