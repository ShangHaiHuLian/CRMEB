FROM php:7.4-fpm
WORKDIR "/var/www"

# 使用国内镜像源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \ 
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update -o Acquire::Check-Valid-Until=false && apt-get install -y --no-install-recommends \ 
        libfreetype6-dev \ 
        libjpeg62-turbo-dev \ 
        libpng-dev \ 
        libzip-dev \ 
        git \ 
        unzip && \ 
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

# 安装PHP扩展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \ 
    docker-php-ext-install -j$(nproc) \ 
        bcmath \ 
        mysqli \ 
        pdo_mysql \ 
        gd \ 
        zip

# 安装Redis扩展
RUN pecl install redis && docker-php-ext-enable redis

# 修改www-data用户的UID和GID以匹配宿主机用户
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# 检查并创建配置目录，调整open_basedir配置
RUN mkdir -p /usr/local/etc/php/conf.d && \
    echo "open_basedir = /tmp:/var:/var/www" > /usr/local/etc/php/conf.d/open_basedir.ini

#
