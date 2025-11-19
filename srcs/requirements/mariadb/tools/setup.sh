#!/bin/sh

# -------------------------------
#  Prepare directories
# -------------------------------
# Ensure runtime folder exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# -------------------------------
#  Check if the database exists
# -------------------------------
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "[INFO] No database found, initializing..."

    # Create internal MySQL structures
    mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null

    # -------------------------------
    #  First-time SQL configuration
    # -------------------------------
    mysqld --user=mysql --bootstrap << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "[INFO] MariaDB has been initialized successfully."
else
    echo "[INFO] Existing database detected. Skipping initialization."
fi

# -------------------------------
#  Launch MariaDB in normal mode
# -------------------------------
echo "[INFO] Starting MariaDB..."
exec mysqld --user=mysql
