FROM php:7.4-fpm
WORKDIR "/var/www"

# Use domestic mirror sources
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# Install system dependencies
RUN apt-get update -o Acquire::Check-Valid-Until=false && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        git \
        unzip \
        procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \ 
    docker-php-ext-install -j$(nproc) \ 
        bcmath \ 
        mysqli \ 
        pdo_mysql \ 
        gd \ 
        zip \
        pcntl

# Install Redis extension with version specified
RUN pecl install -o -f redis-5.3.7 && docker-php-ext-enable redis

# Modify www-data user UID and GID to match host user
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# 删除下面两行重复的open_basedir配置
# Check and create configuration directory, adjust open_basedir configuration
# RUN mkdir -p /usr/local/etc/php/conf.d && \
#    echo "open_basedir = /tmp:/var:/var/www:/dev/null" > /usr/local/etc/php/conf.d/open_basedir.ini
