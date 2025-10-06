#!/bin/sh
set -e

if [ -f /run/secrets/grafana_admin_user ]; then
    export GF_SECURITY_ADMIN_USER=$(cat /run/secrets/grafana_admin_user)
fi

if [ -f /run/secrets/grafana_admin_password ]; then
    export GF_SECURITY_ADMIN_PASSWORD=$(cat /run/secrets/grafana_admin_password)
fi

exec su-exec grafana "$@"
