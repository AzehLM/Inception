#!/bin/sh
set -e

MARIADB_DATABASE=$(cat /run/secrets/mariadb_database)
MARIADB_PASSWORD=$(cat /run/secrets/mariadb_password)
MARIADB_USER=$(cat /run/secrets/mariadb_user)
WP_ADMIN_USER=$(cat /run/secrets/wp-superadmin-user)

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
cd /var/www/html

if [ ! -f wp-config.php ]; then

    wp core download --allow-root

    wp config create \
        --dbhost=mariadb:3306 \
        --dbname="$MARIADB_DATABASE" \
        --dbuser="$MARIADB_USER" \
        --dbpass="$MARIADB_PASSWORD" \
        --allow-root

    if ! wp core is-installed --allow-root; then
            wp core install \
                --url="https://$DOMAIN" \
                --title="Fkin Website" \
                --admin_user="$WP_ADMIN_USER" \
                --admin_password="$MARIADB_PASSWORD" \
                --admin_email="admin@$DOMAIN" \
                --skip-email \
                --allow-root
        # Create a regular non-admin user
        # wp user create \
        #     regularuser \
        #     "user@$DOMAIN" \
        #     --user_pass="userpass123" \
        #     --role=subscriber \
        #     --allow-root

        echo "WordPress installation completed!"
    else
        echo "WordPress already installed."
    fi
fi

exec "$@"



