FROM php:7.3-fpm
MAINTAINER themoroccan09 <themoroccan@github>


# Install utilities
RUN apt-get update \
        && apt-get install -y \
		libzip-dev \
                zip \
                unzip \
                wget \
                curl \
                git \
                nano \
                openssl \
                cron \
        && rm -rf /var/lib/apt/lists/*

# gd
RUN buildRequirements="libpng-dev libjpeg-dev libfreetype6-dev" \
        && apt-get update && apt-get install -y ${buildRequirements} \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/lib \
        && docker-php-ext-install gd \
        && apt-get purge -y ${buildRequirements} \
        && rm -rf /var/lib/apt/lists/*

# pdo_mysql
RUN docker-php-ext-install pdo_mysql

# mysqli
RUN docker-php-ext-install mysqli

# zip
RUN buildRequirements="zlib1g-dev" \
        && apt-get update && apt-get install -y ${buildRequirements} \
        && docker-php-ext-install zip \
        && apt-get purge -y ${buildRequirements} \
        && rm -rf /var/lib/apt/lists/*

# xml
RUN	apt-get update \
	&& apt-get install -y \
	libxml2-dev \
	libxslt-dev \
	&& docker-php-ext-install \
		dom \
		xmlrpc \
		xsl

# BCMath 
RUN docker-php-ext-install bcmath

#Composer
RUN	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
        php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/local/bin/composer 


# create symlink to support standard /usr/bin/php
RUN ln -s /usr/local/bin/php /usr/bin/php


# Activate login for user www-data
RUN chsh www-data -s /bin/bash

WORKDIR /var/www
EXPOSE 9000

