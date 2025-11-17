FROM alpine:3.21

RUN apk update && apk add nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=France/L=Nice/O=42/OU=Student/CN=aldalmas.42.fr"

COPY conf/default.conf /etc/nginx/http.d/default.conf

COPY www /var/www/html

CMD ["nginx", "-g", "daemon off;"]