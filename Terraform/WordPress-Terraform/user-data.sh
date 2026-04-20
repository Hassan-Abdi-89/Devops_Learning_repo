#!/bin/bash
exec > /var/log/user-data.log 2>&1

echo "=== Starting WordPress bootstrap ==="

# ── 1. Update package list only (no upgrade — it hangs in user_data) ──────────
export DEBIAN_FRONTEND=noninteractive
apt-get update -y

echo "=== Package list updated ==="

# ── 2. Install everything in one command ──────────────────────────────────────
apt-get install -y --fix-missing \
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

# ── 3. Start services ─────────────────────────────────────────────────────────
systemctl enable --now apache2
systemctl enable --now mariadb

echo "=== Services started ==="

# ── 4. Verify Apache is up before copying files ───────────────────────────────
sleep 5
systemctl is-active apache2 || { echo "Apache failed to start"; exit 1; }

echo "=== Apache confirmed running ==="

# ── 5. Download WordPress ─────────────────────────────────────────────────────
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

# Confirm extraction worked before copying
if [ ! -d "/tmp/wordpress" ]; then
  echo "WordPress extraction failed"
  exit 1
fi

cp -r /tmp/wordpress/* /var/www/html/
rm -f /var/www/html/index.html
rm -rf /tmp/wordpress /tmp/latest.tar.gz

echo "=== WordPress downloaded ==="

# ── 6. Permissions ────────────────────────────────────────────────────────────
chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# ── 7. Enable mod_rewrite and restart ─────────────────────────────────────────
a2enmod rewrite
systemctl restart apache2

echo "=== Bootstrap complete ==="
