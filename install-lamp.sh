#!/bin/bash
PHPMYADMIN_VERSION=4.5.4.1

sudo yum -y install httpd
sudo yum -y install mariadb-server mariadb

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum -y install php55w php55w-cli php55w-common php55w-gd php55w-mcrypt php55w-mysqlnd php55w-xml php55w-soap php55w-mbstring

# sudo yum -y install phpmyadmin
sudo curl -S https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.gz | tar zxv -C /var/www/html

sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl start mariadb
sudo systemctl enable mariadb
#sudo mysql_secure_installation
