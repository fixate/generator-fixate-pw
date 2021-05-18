FROM php:7.4.19-fpm-alpine3.13

RUN apk update; apk upgrade; apk add \
  freetype-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libzip-dev \
  msmtp \
  zziplib-utils

# fix iconv issue: https://github.com/nunomaduro/phpinsights/issues/43#issuecomment-498108857
RUN apk add --upgrade gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

RUN docker-php-ext-install mysqli pdo_mysql zip \
  # allow for image uploads inside container
  && docker-php-ext-configure gd \
    --with-jpeg \
    --with-freetype \
  && docker-php-ext-install gd

# install Mailhog's mhsendmail
ENV GOPATH /usr/src/gocode
RUN apk add --no-cache go git musl-dev \
  && go get github.com/mailhog/mhsendmail && mv ${GOPATH}/bin/mhsendmail /usr/bin \
  && rm -rf ${GOPATH} && apk del go git musl-dev
COPY mail.ini $PHP_INI_DIR/conf.d/

# install Xdebug: https://github.com/aschmelyun/docker-compose-laravel/pull/10/commits/c836d85b33302b49d5c4b540f40513316490756d
RUN apk --no-cache add --virtual .build-deps \
        g++ \
        autoconf \
        make && \
    pecl install xdebug-2.9.2 && \
    docker-php-ext-enable xdebug && \
    apk del .build-deps && \
    rm -r /tmp/pear/*

