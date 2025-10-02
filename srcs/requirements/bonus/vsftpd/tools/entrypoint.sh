#!/bin/sh
set -e

FTP_USER=${FTP_USER:-ftpuser}
FTP_PASS=${FTP_PASS:-changeme}

echo "==> Setting up FTP user: $FTP_USER"

# Create user if it doesn't exist
if ! id "$FTP_USER" >/dev/null 2>&1; then
    echo "==> Creating user $FTP_USER"
    adduser -D -h /var/www/html "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
else
    echo "==> User $FTP_USER already exists"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
fi

chown -R "$FTP_USER:$FTP_USER" /var/www/html
chmod 755 /var/www/html

echo "==> FTP user setup complete"
echo "==> Starting vsftpd..."

exec "$@"
