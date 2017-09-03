#!/bin/bash

## Variables ##
PHPMYADMIN_VERSION=4.5.4.1
TIME_ZONE=Australia/Adelaide

JAVA_VERSION=8u112-b15
JAVA_INSTALLER=jdk-8u112-linux-x64.rpm
JAVA_PROFILE=/etc/profile.d/java.sh

MAVEN_VERSION=3.0.5
MAVEN_ROOT=/opt/maven

MONGODB_VERSION=2.6.11

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
sudo curl -S https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.gz | tar zxv -C /var/www/html

sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl start mariadb
sudo systemctl enable mariadb
#sudo mysql_secure_installation

## Install Oracle Java ##
#sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}/${JAVA_INSTALLER}"
sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}/${JAVA_INSTALLER}
sudo yum -y install ${JAVA_INSTALLER}

sudo mkdir -p ${MAVEN_ROOT}
sudo curl -s "https://archive.apache.org/dist/maven/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" | tar zxv -C ${MAVEN_ROOT}
cd ${MAVEN_ROOT}
sudo ln -sf apache-maven-${MAVEN_VERSION} apache-maven
sudo ln -sf ${MAVEN_ROOT}/apache-maven/bin/mvn /usr/local/bin/mvn

sudo curl -s "https://raw.githubusercontent.com/kevinlinxp/linux-server-helper/master/init/centos/7.1x64/etc/profile.d/java.sh" > ${JAVA_PROFILE}
source ${JAVA_PROFILE}

## Install MongoDB ##
sudo curl -s "https://raw.githubusercontent.com/kevinlinxp/linux-server-helper/master/init/centos/7.1x64/etc/yum.repos.d/mongodb.repo" > /etc/yum.repos.d/mongodb.repo
sudo yum install -y mongodb-org-${MONGODB_VERSION} mongodb-org-server-${MONGODB_VERSION} mongodb-org-shell-${MONGODB_VERSION} mongodb-org-mongos-${MONGODB_VERSION} mongodb-org-tools-${MONGODB_VERSION}
sudo echo "exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools" >> /etc/yum.conf
sudo semanage port -a -t mongod_port_t -p tcp 27017
sudo service mongod start #sudo systemctl start mongod.service
sudo chkconfig mongod on

## Install nodejs
sudo yum install epel-release
sudo rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm && yum -y install nodejs
