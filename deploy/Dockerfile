FROM php:8.3-apache-bookworm

ARG QLOAPPS_VERSION=1.7.0

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl unzip libcurl4-openssl-dev libfreetype6-dev \
      libjpeg62-turbo-dev libpng-dev libwebp-dev libzip-dev libxml2-dev \
      libonig-dev libicu-dev libxslt1-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" gd intl mbstring mysqli pdo_mysql soap xml xsl zip \
    && a2enmod rewrite headers expires \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/Qloapps/QloApps/releases/download/v${QLOAPPS_VERSION}/qloapps-${QLOAPPS_VERSION}.zip" -o /tmp/qloapps.zip \
    && mkdir -p /opt/qloapps \
    && unzip -q /tmp/qloapps.zip -d /tmp/qloapps-release \
    && cp -a "/tmp/qloapps-release/qloapps-${QLOAPPS_VERSION}/." /opt/qloapps/ \
    && rm -rf /tmp/qloapps.zip /tmp/qloapps-release

COPY deploy/apache-port.conf /etc/apache2/ports.conf
COPY deploy/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY deploy/entrypoint.sh /usr/local/bin/qloapps-entrypoint
RUN chmod 0755 /usr/local/bin/qloapps-entrypoint \
    && printf 'ServerName localhost\n' > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername \
    && printf 'memory_limit=256M\nmax_execution_time=500\nallow_url_fopen=On\nupload_max_filesize=32M\npost_max_size=40M\n' > /usr/local/etc/php/conf.d/qloapps.ini \
    && mkdir -p /var/www/html /var/lib/qloapps \
    && chown -R www-data:www-data /var/lib/qloapps

EXPOSE 10000
ENTRYPOINT ["/usr/local/bin/qloapps-entrypoint"]
CMD ["apache2-foreground"]
