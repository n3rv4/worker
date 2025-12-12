FROM php:8.4-cli-bullseye AS worker_base

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        git \
        unzip \
        curl \
        mariadb-client \
        libicu-dev \
        libzip-dev \
        libonig-dev \
        default-mysql-client \
    && docker-php-ext-install intl pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
      -o /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions

ENV PHP_INI_SCAN_DIR=":$PHP_INI_DIR/app.conf.d"

RUN install-php-extensions pdo_mysql

# PHP Config
COPY build/conf.d/10-app.ini $PHP_INI_DIR/app.conf.d/