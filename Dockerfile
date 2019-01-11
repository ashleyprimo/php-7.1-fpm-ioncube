FROM php:7.1-fpm

MAINTAINER Ashley Primo <ashley@primonetwork.co.uk>

RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && \
rm -rf /tmp/composer-setup.php

RUN apt-get update && \
apt-get install -y git unzip curl

RUN apt-get update && \
apt-get install -y \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
libsqlite3-dev \
libcurl4-gnutls-dev \
libxml2-dev \
libcurl4-gnutls-dev \
librtmp-dev \
libc-client-dev \
libpq-dev \
libkrb5-dev \
libldap2-dev \
zlib1g-dev \
libicu-dev \
g++ \
&& docker-php-ext-install -j$(nproc) iconv mcrypt gd pdo_mysql pcntl pdo_sqlite zip curl bcmath opcache mbstring json mysqli xml pdo_pgsql pdo_mysql pgsql pdo intl gettext \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-enable iconv mcrypt gd pdo_mysql pcntl pdo_sqlite zip curl bcmath opcache mbstring json mysqli xml pdo_pgsql pdo_mysql pgsql pdo intl gettext \
&& apt-get autoremove -y

RUN cd /tmp \
&& curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
&& tar -xvvzf ioncube.tar.gz \
&& mv ioncube/ioncube_loader_lin_7.1.so /usr/local/lib/php/extensions/* \
&& rm -Rf ioncube.tar.gz ioncube \
&& echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/ioncube_loader_lin_7.1.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_7.1.ini

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm"]

