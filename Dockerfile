FROM php:8.1-apache
ENV APACHE_DOCUMENT_ROOT /app/src
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY ./src /app/src
COPY ./tests /app/tests
COPY ./test /app/test

WORKDIR /app

EXPOSE 80

