#!/bin/bash
JAVA_VERSION=8u112-b15
JAVA_INSTALLER=jdk-8u112-linux-x64.rpm
JAVA_PROFILE=/etc/profile.d/java.sh

MAVEN_VERSION=3.0.5
MAVEN_ROOT=/opt/maven

sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}/${JAVA_INSTALLER}
sudo yum -y install ${JAVA_INSTALLER}

sudo mkdir -p ${MAVEN_ROOT}
sudo curl -s "https://archive.apache.org/dist/maven/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" | tar zxv -C ${MAVEN_ROOT}
cd ${MAVEN_ROOT}
sudo ln -sf apache-maven-${MAVEN_VERSION} apache-maven
sudo ln -sf ${MAVEN_ROOT}/apache-maven/bin/mvn /usr/local/bin/mvn

sudo curl -s "https://raw.githubusercontent.com/kevinlinhelloworld/linux-server-helper/master/init/centos/7.1x64/etc/profile.d/java.sh" > ${JAVA_PROFILE}
source ${JAVA_PROFILE}
