#!/bin/sh
set -e

# Read secrets
if [ -f /run/secrets/grafana_admin_user ]; then
    export GF_SECURITY_ADMIN_USER=$(cat /run/secrets/grafana_admin_user)
fi

if [ -f /run/secrets/grafana_admin_password ]; then
    export GF_SECURITY_ADMIN_PASSWORD=$(cat /run/secrets/grafana_admin_password)
fi

# Switch to grafana user and execute command
exec su-exec grafana "$@"
