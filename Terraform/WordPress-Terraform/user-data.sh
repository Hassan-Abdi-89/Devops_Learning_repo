#!/bin/bash
set -euo pipefail
exec > /var/log/user-data.log 2>&1

# ── 1. Update ─────────────────────────────────────────────────────────────────
yum update -y

# ── 2. Install PHP first, then Apache ────────────────────────────────────────
# php-mysqlnd is critical — without it WordPress cannot talk to the database
amazon-linux-extras install php8.0 -y
yum install -y httpd php php-mysqlnd php-json php-xml php-mbstring mariadb-server

# ── 3. Start services ─────────────────────────────────────────────────────────
systemctl enable --now mariadb
systemctl enable --now httpd

# ── 4. Download WordPress ─────────────────────────────────────────────────────
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress latest.tar.gz

# ── 5. Permissions ────────────────────────────────────────────────────────────
chown -R apache:apache /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# ── 6. Restart Apache ─────────────────────────────────────────────────────────
systemctl restart httpd
