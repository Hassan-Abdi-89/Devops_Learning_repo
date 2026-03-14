#!/bin/bash
set -o pipefail
exec > /var/log/user-data.log 2>&1

echo "=== Starting WordPress bootstrap ==="

# ── 1. Update ─────────────────────────────────────────────────────────────────
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

echo "=== System updated ==="

# ── 2. Install Apache, PHP, and MariaDB ───────────────────────────────────────
apt-get install -y \
  apache2 \
  php \
  php-mysql \
  php-curl \
  php-json \
  php-xml \
  php-mbstring \
  mariadb-server \
  wget \
  curl

echo "=== Packages installed ==="

# ── 3. Start and enable services ──────────────────────────────────────────────
systemctl enable --now apache2
systemctl enable --now mariadb

echo "=== Services started ==="

# ── 4. Download WordPress ─────────────────────────────────────────────────────
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress latest.tar.gz

# Remove default Apache page
rm -f /var/www/html/index.html

echo "=== WordPress downloaded ==="

# ── 5. Permissions ────────────────────────────────────────────────────────────
chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# ── 6. Enable Apache mod_rewrite (needed for WordPress permalinks) ─────────────
a2enmod rewrite
systemctl restart apache2

echo "=== Bootstrap complete ==="