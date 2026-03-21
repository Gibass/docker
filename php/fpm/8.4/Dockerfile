FROM php:8.4-fpm-alpine

# Optional Xdebug install for local debugging (disabled by default for performance).
ARG INSTALL_XDEBUG=0

# Install runtime libraries, compile PHP extensions, then drop build-only packages.
RUN set -eux; \
    apk add --no-cache \
        git \
        icu-data-full \
        icu-libs \
        libpq \
        libzip \
        unzip \
        zip \
    ; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        libzip-dev \
        linux-headers \
        postgresql-dev \
    ; \
    docker-php-ext-install -j"$(nproc)" \
        bcmath \
        intl \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        zip \
    ; \
    if [ "$INSTALL_XDEBUG" = "1" ]; then \
        pecl install xdebug; \
        docker-php-ext-enable xdebug; \
    fi; \
    apk del --no-network .build-deps

# Copy Composer binary from official image.
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Default PHP config with common performance settings for dev and prod.
COPY conf.d/99-common-performance.ini /usr/local/etc/php/conf.d/99-common-performance.ini

# Entrypoint that optionally imports custom *.ini files mounted at runtime.
COPY scripts/php-entrypoint.sh /usr/local/bin/php-entrypoint.sh
RUN chmod +x /usr/local/bin/php-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["php-entrypoint.sh"]
CMD ["php-fpm"]
