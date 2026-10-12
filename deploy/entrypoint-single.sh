#!/bin/sh
set -eu

: "${SANDBOX_USER:?Set SANDBOX_USER in the Render environment}"
: "${SANDBOX_PASSWORD:?Set SANDBOX_PASSWORD in the Render environment}"

mkdir -p /var/run/mysqld /var/lib/qloapps /var/www/html
chown -R mysql:mysql /var/run/mysqld
htpasswd -bcB /var/lib/qloapps/.htpasswd "$SANDBOX_USER" "$SANDBOX_PASSWORD"
chown root:www-data /var/lib/qloapps/.htpasswd
chmod 0640 /var/lib/qloapps/.htpasswd

# Render Free has an ephemeral filesystem, so this is strictly demonstration data.
service mariadb start
tries=0
until mysqladmin ping --silent; do
    tries=$((tries + 1))
    if [ "$tries" -ge 30 ]; then echo "MariaDB did not start" >&2; exit 1; fi
    sleep 1
done
mysql -u root <<'SQL'
CREATE DATABASE IF NOT EXISTS deckvilla_sandbox CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'qloapps'@'localhost' IDENTIFIED BY '';
CREATE USER IF NOT EXISTS 'qloapps'@'127.0.0.1' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON deckvilla_sandbox.* TO 'qloapps'@'localhost';
GRANT ALL PRIVILEGES ON deckvilla_sandbox.* TO 'qloapps'@'127.0.0.1';
FLUSH PRIVILEGES;
SQL

if [ ! -f /var/www/html/index.php ]; then cp -a /opt/qloapps/. /var/www/html/; fi
mkdir -p /var/www/html/config /var/www/html/cache /var/www/html/img /var/www/html/upload /var/www/html/download
chown -R www-data:www-data /var/www/html /var/lib/qloapps
exec docker-php-entrypoint "$@"
