#!/bin/bash

VERSION_PHPMYADMIN=4.5.4.1
TIME_ZONE=Australia/Adelaide


sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

sudo yum -y update
sudo yum -y install epel-release
sudo yum -y clean all

sudo yum -y install git
sudo yum -y install zip unzip
sudo yum -y tree
sudo yum -y install httpd
sudo yum -y install mariadb-server mariadb

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum -y install php55w php55w-cli php55w-common php55w-gd php55w-mcrypt php55w-mysqlnd php55w-xml php55w-soap

# sudo yum -y install phpmyadmin
curl -S https://files.phpmyadmin.net/phpMyAdmin/${VERSION_PHPMYADMIN}/phpMyAdmin-${VERSION_PHPMYADMIN}-english.tar.gz | tar zxv -C /var/www/html

sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo mysql_secure_installation
