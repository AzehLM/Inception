#!/bin/sh
set -e

# Creates needed directory so mariadb can be launched correctly
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start temp instance
    mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"
    sleep 5

    echo "Running initialization SQL..."
    # Expand env vars into a temp SQL file, then feed to mariadb
    envsubst < /docker-entrypoint-initdb.d/init.sql | mariadb -u root

    # Shutdown temp instance
    kill "$pid"
    wait "$pid" || true
fi

exec su-exec mysql "$@"
