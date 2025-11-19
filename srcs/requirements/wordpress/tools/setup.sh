#!/bin/sh

# ----------------------------------------
#  Wait for MariaDB to be ready
# ----------------------------------------
echo "[INFO] Waiting for MariaDB..."

# Try to connect until success
while ! mariadb -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} >/dev/null 2>&1; do
    sleep 1
done

echo "[INFO] MariaDB is ready."

# ----------------------------------------
#  Prepare WordPress files
# ----------------------------------------
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "[INFO] No wp-config found. Installing WordPress..."

    # Download core if missing
    if [ ! -f "/var/www/html/wp-admin/install.php" ]; then
        wp core download --path=/var/www/html --allow-root
    fi

    # Create wp-config.php
    wp config create \
        --path=/var/www/html \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=${MYSQL_HOST} \
        --allow-root

    # Install WordPress
    wp core install \
        --path=/var/www/html \
        --url=${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --allow-root

    # Optional: create a second user
    if [ ! -z "$WP_USER" ]; then
        wp user create \
            ${WP_USER} ${WP_USER_EMAIL} \
            --user_pass=${WP_USER_PASSWORD} \
            --role=author \
            --path=/var/www/html \
            --allow-root
    fi

    echo "[INFO] WordPress installation completed."
else
    echo "[INFO] WordPress already installed. Skipping."
fi

# ----------------------------------------
#  Start PHP-FPM in foreground
# ----------------------------------------
echo "[INFO] Starting php-fpm..."
exec php-fpm82 -F
