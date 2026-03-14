#!/bin/bash
set -o pipefail
exec > /var/log/user-data.log 2>&1

echo "=== Starting bootstrap ==="

# ── 1. Update — skip unreachable repos rather than aborting everything ────────
yum update -y --skip-broken || true

echo "=== System updated ==="

# ── 2. Install PHP first, then Apache and MariaDB ────────────────────────────
amazon-linux-extras install php8.0 -y
yum install -y httpd php php-mysqlnd php-json php-xml php-mbstring mariadb-server

echo "=== Packages installed ==="

# ── 3. Start and enable services ─────────────────────────────────────────────
systemctl enable --now mariadb
systemctl enable --now httpd

echo "=== Services started ==="

# ── 4. Download WordPress ─────────────────────────────────────────────────────
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress latest.tar.gz

echo "=== WordPress downloaded ==="

# ── 5. Permissions ────────────────────────────────────────────────────────────
chown -R apache:apache /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# ── 6. Restart Apache ─────────────────────────────────────────────────────────
systemctl restart httpd

echo "=== Bootstrap complete ==="