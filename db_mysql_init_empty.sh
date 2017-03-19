#!/bin/bash

function show_usage_and_exit() {
    echo "Usage: db_name=<db_name> db_user=<db_user> db_password=<db_password> [mysql_root=<mysql_root>] [mysql_root_password=<mysql_root_password>] $0"
    exit 0
}

if [ -z "$mysql_root" ]; then
  mysql_root=root
fi

if [ -z "$mysql_root_password" ]; then
    read -s -p "Please enter mysql root password:" mysql_root_password
    echo ""
fi

if [ -z "$db_name" ]; then
  show_usage_and_exit
fi

if [ -z "$db_user" ]; then
  show_usage_and_exit
fi

if [ -z "$db_password" ]; then
  show_usage_and_exit
fi

echo -e "\nInitializing an empty database (db_name=$db_name;db_user=$db_user;db_password=$db_password) ..."

mysql -hlocalhost -u${mysql_root} -p${mysql_root_password} -e"\
DROP DATABASE IF EXISTS \`$db_name\`;\
GRANT USAGE ON *.* TO \`$db_user\`@\`localhost\`;\
DROP USER \`$db_user\`@\`localhost\`;\
GRANT USAGE ON *.* TO \`$db_user\`@\`127.0.0.1\`;\
DROP USER \`$db_user\`@\`127.0.0.1\`;\
\
CREATE DATABASE \`$db_name\`;\
CREATE USER \`$db_user\`@\`localhost\` identified by '$db_password';\
CREATE USER \`$db_user\`@\`127.0.0.1\` identified by '$db_password';\
GRANT ALL PRIVILEGES ON \`$db_name\`.* to \`$db_user\`@\`localhost\`;\
GRANT ALL PRIVILEGES ON \`$db_name\`.* to \`$db_user\`@\`127.0.0.1\`;"
echo -e "\nDone."
