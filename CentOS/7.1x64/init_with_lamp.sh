#!/bin/bash

## Variables ##
VERSION_PHPMYADMIN=4.5.4.1
TIME_ZONE=Australia/Adelaide

VERSION_JAVA=8u73-b02
JAVA_INSTALLER=jdk-8u73-linux-x64.rpm
JAVA_PROFILE=/etc/profile.d/java.sh

## Common Updates ##
sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

sudo yum -y update
sudo yum -y install epel-release
sudo yum -y clean all

sudo yum -y install git
sudo yum -y install zip unzip
sudo yum -y tree

## Install LAMP ##
sudo yum -y install httpd
sudo yum -y install mariadb-server mariadb

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum -y install php55w php55w-cli php55w-common php55w-gd php55w-mcrypt php55w-mysqlnd php55w-xml php55w-soap php55w-mbstring

# sudo yum -y install phpmyadmin
curl -S https://files.phpmyadmin.net/phpMyAdmin/${VERSION_PHPMYADMIN}/phpMyAdmin-${VERSION_PHPMYADMIN}-english.tar.gz | tar zxv -C /var/www/html

sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl start mariadb
sudo systemctl enable mariadb

#sudo mysql_secure_installation

## Install Oracle Java ##
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${VERSION_JAVA}/${JAVA_INSTALLER}"
sodu yum -y install ${JAVA_INSTALLER}
curl -s "https://raw.githubusercontent.com/kelindev/scripts/master/CentOS/etc/profile.d/java.sh" > ${JAVA_PROFILE}
source ${JAVA_PROFILE}
