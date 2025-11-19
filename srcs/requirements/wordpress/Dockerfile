FROM alpine:3.21


RUN apk update && apk add \
    --no-cache mariadb-client \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-iconv \
    wget \
    tar

# dl wordpress and extract it
RUN mkdir -p /var/www/html && \
    wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz && \
    tar -xzf /tmp/wp.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/wp.tar.gz

# PHP-FPM must listen 9000 ngix port
RUN sed -i 's|listen = 127.0.0.1:9000|listen = 9000|' /etc/php82/php-fpm.d/www.conf

# Donner les droits à nginx (ou www-data, selon ton choix)
RUN adduser -S www-data && \
    chown -R www-data:www-data /var/www/html

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
