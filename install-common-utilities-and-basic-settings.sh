#!/bin/bash
TIME_ZONE=Australia/Adelaide

sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

sudo yum -y update
sudo yum -y install epel-release
sudo yum -y clean all

sudo yum -y install git
sudo yum -y install zip unzip
sudo yum -y tree