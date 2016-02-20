#!/bin/bash
function show_usage_and_exit() {
    echo "Usage: remote=<user@host> mysql_dbname=<mysql_dbname> mysql_dbuser=<mysql_dbuser> [mysql_dbpassword=<mysql_dbpassword>] [local_mysql_root=<local_mysql_root>] [local_mysql_root_password=<local_mysql_root_password>] replace=<replace> $0"
    exit 0
}

if [ -z "$remote" ]; then
	show_usage_and_exit
fi

if [ -z "$mysql_dbname" ]; then
	show_usage_and_exit
fi

if [ -z "$mysql_dbuser" ]; then
	show_usage_and_exit
fi

if [ -z "$mysql_dbpassword" ]; then
    read -s -p "Please enter mysql user password for $mysql_dbuser on $remote:" mysql_dbpassword
    echo ""
fi

if [ -z "$local_mysql_root" ]; then
	local_mysql_root=root
fi

if [ -z "$local_mysql_root_password" ]; then
    read -s -p "Please enter localhost mysql root password:" local_mysql_root_password
    echo ""
fi

DUMP_FILE=${mysql_dbname}.db.mysql.$(date +%Y%m%d-%H%M%S)
DUMP_FILE_GZ=${DUMP_FILE}.gz
DUMP_FILE_LOCAL=${DUMP_FILE}.local

echo -e "\nDownloading remote datebase..."
ssh -C ${remote} "mysqldump -u$mysql_dbuser -p$mysql_dbpassword --compress $mysql_dbname | gzip -9 -c" > ${DUMP_FILE_GZ}
gunzip ${DUMP_FILE_GZ}

if [ -n "$replace" ]; then
	echo -e "\nReplacing strings..."
	LANG=C sed -e "$replace" ${DUMP_FILE} > ${DUMP_FILE_LOCAL}
else
	cp ${DUMP_FILE} ${DUMP_FILE_LOCAL}
fi

echo -e "\nCreating database..."
mysql -u${local_mysql_root} -p${local_mysql_root_password} -hlocalhost -e"\
DROP DATABASE IF EXISTS \`$mysql_dbname\`;\
GRANT USAGE ON *.* TO \`$mysql_dbuser\`@\`localhost\`;\
DROP USER \`$mysql_dbuser\`@\`localhost\`;\
GRANT USAGE ON *.* TO \`$mysql_dbuser\`@\`127.0.0.1\`;\
DROP USER \`$mysql_dbuser\`@\`127.0.0.1\`;\
\
CREATE DATABASE \`$mysql_dbname\`;\
CREATE USER \`$mysql_dbuser\`@\`localhost\` identified by '$mysql_dbpassword';\
CREATE USER \`$mysql_dbuser\`@\`127.0.0.1\` identified by '$mysql_dbpassword';\
GRANT ALL PRIVILEGES ON $mysql_dbname.* to \`$mysql_dbuser\`@\`localhost\`;\
GRANT ALL PRIVILEGES ON $mysql_dbname.* to \`$mysql_dbuser\`@\`127.0.0.1\`;\
USE \`$mysql_dbname\`;\
SOURCE $DUMP_FILE_LOCAL;"

rm ${DUMP_FILE}
rm ${DUMP_FILE_LOCAL}
echo "Done!"