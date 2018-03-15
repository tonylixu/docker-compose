FROM php:7.1.15-apache

ENV DOCKER_PHP_EXT_INSTALL="exif gd mysqli opcache pcntl zip"
ENV DOCKER_PHP_PECL_INSTALL="apcu igbinary memcached redis"

ENV PHP_COMPATIBILITY_VERSION 8.0.1

COPY ./build.sh /build.sh
COPY ./build_apache.sh /build_apache.sh
RUN /build.sh && rm /build*.sh
