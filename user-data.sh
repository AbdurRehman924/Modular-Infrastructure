#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html
echo "<p>Instance Type: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>" >> /var/www/html/index.html
