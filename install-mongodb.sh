#!/bin/bash
MONGODB_VERSION=2.6.11

sudo curl -s "https://raw.githubusercontent.com/kevinlinhelloworld/linux-server-helper/master/init/centos/7.1x64/etc/yum.repos.d/mongodb.repo" > /etc/yum.repos.d/mongodb.repo
sudo yum install -y mongodb-org-${MONGODB_VERSION} mongodb-org-server-${MONGODB_VERSION} mongodb-org-shell-${MONGODB_VERSION} mongodb-org-mongos-${MONGODB_VERSION} mongodb-org-tools-${MONGODB_VERSION}
sudo echo "exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools" >> /etc/yum.conf
sudo semanage port -a -t mongod_port_t -p tcp 27017
sudo service mongod start #sudo systemctl start mongod.service
sudo chkconfig mongod on
