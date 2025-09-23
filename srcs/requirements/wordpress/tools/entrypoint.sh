#!/bin/sh
set -e

wp core download

# replace by looking into secrest file, rn not secured {cat secret/path/to/file/expected}
wp config create --dbhost=mariadb:3306 --dbname=db --dbuser=mysql --dbpass=gueberso

wp core install --url=$DOMAIN --title=Temp --admin_user=mysql --admin_email=temp@email.mail --skip-email --locale=en_US




# Start php-fpm
exec php-fpm83 --nodaemonize --fpm-config /etc/php83/www.conf
