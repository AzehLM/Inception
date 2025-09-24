#!/bin/sh
set -e

wp core download

# replace by looking into secrets files, right now not secured {cat secret/path/to/file/expected}
wp config create \
	--dbhost=mariadb:3306 \
	--dbname=db \
	--dbuser=mysql \
	--dbpass=gueberso

wp core install \
	--url=$DOMAIN \
	--title=Temp \
	--admin_user=mysql \
	--admin_email=temp@email.mail --skip-email \
	--locale=en_US # this one is by default, might want to delete it since its not relevant

# Start php-fpm
exec php-fpm83 --nodaemonize --fpm-config /etc/php83/www.conf
