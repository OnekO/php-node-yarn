FROM php:7.3-fpm

# Install selected extensions and other stuff
RUN apt-get update && apt-get install -y \
        wget \
        apt-transport-https \
        apt-utils \
        openssh-client \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        wkhtmltopdf \
        xvfb \
        libssl-dev \
        pkg-config \
        zip \
        unzip \
        git \
        libjpeg62-turbo-dev \
        webp \
        libwebp-dev \
        libxpm-dev \
        imagemagick \
        libtool \
        libmagickwand-dev \
        libmagickcore-dev \
        libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip \
    && docker-php-ext-configure gd \
          --with-freetype-dir=/usr/include/ \
          --with-jpeg-dir=/usr/include/ \
          --with-webp-dir=/usr/include/ \
          --with-png-dir=/usr/include/ \
          --with-xpm-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) exif gd

RUN pecl install redis \
    && pecl install imagick-3.4.3 \
    && pecl install xdebug \
    && pecl install apcu \
    && pecl install mongodb \
    && docker-php-ext-enable redis xdebug apcu mongodb imagick

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -yqq

RUN wget https://getcomposer.org/installer
RUN php installer --install-dir=/usr/local/bin --filename=composer && composer global require hirak/prestissimo
