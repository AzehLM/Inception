# #!/bin/sh
# set -e

# # Ensure we have WordPress sources in /var/www/html
# if [ ! -f /var/www/html/wp-config.php ]; then
#   # Download only if not preset:
#   wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz
#   tar -xzf /tmp/wp.tar.gz --strip-components=1 -C /var/www/html
#   rm /tmp/wp.tar.gz
#   chown -R nobody:nobody /var/www/html
# fi

# # Start php-fpm
# exec php-fpm83 --nodaemonize --fpm-config /etc/php83/www.conf
