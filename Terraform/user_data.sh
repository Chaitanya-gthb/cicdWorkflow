#!/bin/bash

yum update -y

yum install -y httpd

systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/index.html
<html>
<h1>Application deployed by Terraform + GitHub Actions</h1>
</html>
EOF