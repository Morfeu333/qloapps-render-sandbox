#!/bin/sh
set -eu

APP_ROOT=/var/www/html
DATA_ROOT=/var/lib/qloapps

mkdir -p "$DATA_ROOT/config" "$DATA_ROOT/img" "$DATA_ROOT/upload" "$DATA_ROOT/download"

# Seed the persistent QloApps state once. On later releases replace application
# files from the image while retaining installer config and user-uploaded media.
if [ ! -f "$DATA_ROOT/.initialized" ]; then
    cp -a /opt/qloapps/. "$APP_ROOT/"
    cp -a "$APP_ROOT/img/." "$DATA_ROOT/img/"
    cp -a "$APP_ROOT/upload/." "$DATA_ROOT/upload/" 2>/dev/null || true
    cp -a "$APP_ROOT/download/." "$DATA_ROOT/download/" 2>/dev/null || true
    touch "$DATA_ROOT/.initialized"
else
    cp -a /opt/qloapps/. "$APP_ROOT/"
fi

mkdir -p "$APP_ROOT/config"
if [ -f "$DATA_ROOT/config/settings.inc.php" ]; then
    rm -f "$APP_ROOT/config/settings.inc.php"
fi
if [ ! -e "$APP_ROOT/config/settings.inc.php" ]; then
    ln -s "$DATA_ROOT/config/settings.inc.php" "$APP_ROOT/config/settings.inc.php"
fi

for name in img upload download; do
    rm -rf "$APP_ROOT/$name"
    ln -s "$DATA_ROOT/$name" "$APP_ROOT/$name"
done

chown -R www-data:www-data "$DATA_ROOT" "$APP_ROOT"
chmod 0775 "$DATA_ROOT" "$DATA_ROOT/config" "$DATA_ROOT/img" "$DATA_ROOT/upload" "$DATA_ROOT/download"

exec docker-php-entrypoint "$@"
