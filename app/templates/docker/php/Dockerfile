FROM php:7.3-fpm-alpine

RUN apk update; apk upgrade;
RUN apk add freetype-dev libjpeg-turbo-dev libpng-dev zziplib-utils msmtp

# fix iconv issue: https://github.com/docker-library/php/issues/240#issuecomment-327992638
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk add --no-cache libpng-dev zlib-dev libzip-dev \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip

RUN docker-php-ext-install mysqli pdo_mysql \
  # allow for image uploads inside container
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd

# install Mailhog's mhsendmail
ENV GOPATH /usr/src/gocode
RUN apk add --no-cache go git musl-dev
RUN go get github.com/mailhog/mhsendmail && mv ${GOPATH}/bin/mhsendmail /usr/bin
RUN rm -rf ${GOPATH} && apk del go git musl-dev
COPY mail.ini $PHP_INI_DIR/conf.d/

# install Xdebug: https://gist.github.com/patricknelson/57ae24986cb13613314fb1f3c00a95d7
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  # Clean up
  && apk del .phpize-deps
