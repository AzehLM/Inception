#!/bin/sh
set -e


mkdir -p /var/www/html
rm -rf /var/www/html/*

cd /var/www/html

wp core download

# replace by looking into secrets files, right now not secured {cat secret/path/to/file/expected}
# for now, --dbhost=3306:3306
# tested, working if wordpress is on the same network as mariadb, otherwise its a mess
wp config create \
	--dbhost=mariadb:3306 \
	--dbname=db \
	--dbuser=mysql \
	--dbpass=gueberso \
	--allow-root

# tested, good
wp core install \
	--url="https://$DOMAIN" \
	--title="Temp" \
	--admin_user="mysql" \
	--admin_password="gueberso" \
	--admin_email="temp@email.mail" \
	--skip-email \
	--allow-root

# completly lost from here

# Start php-fpm

exec $@
