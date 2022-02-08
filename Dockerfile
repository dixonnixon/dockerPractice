FROM php:7.4-fpm


RUN apt-get update -y
RUN apt-get -y install gcc make autoconf libc-dev pkg-config libzip-dev

# Arguments defined in docker-compose.yml
ARG user
ARG uid
ARG githubuser
ARG githubrepo

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user 
RUN chmod g+rwx /home/$user/.composer/ -R

RUN echo 'root:Docker!' | chpasswd

# RUN cd /var/www/html && composer init
RUN mkdir /var/www/html/domainModel
# COPY ./app/ /var/www/html/domainModel/
COPY ./backend/composer.json /var/www/html/composer.json
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer install --ignore-platform-reqs --no-interaction


# RUN cd /var/www/html/domainModel
# RUN git init
# RUN git remote add origin https://github.com/$githubuser/$githubrepo.git
# RUN git pull origin master
RUN apt-get update && \
      apt-get -y install sudo
RUN useradd -ms /bin/bash docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN apt-get update && apt-get install  bash
RUN apt-get install -y iputils-ping

RUN chmod 777 -R /var/www/html/vendor/bin/
RUN chown -R $user ~/.composer/
RUN chown -R $user /var/www/html/vendor/composer/


# USER docker
# CMD /bin/bash


# Set working directory
WORKDIR /var/www/html/domainModel

RUN ln -sf /bin/bash /bin/sh

USER $user

EXPOSE 9000

CMD ["php-fpm"]