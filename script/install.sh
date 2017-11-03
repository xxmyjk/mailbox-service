#!/bin/sh

# start
echo "start install deps ..."

# set apk repo
apk update

# install deps
apk add postfix postfix-mysql dovecot dovecot-mysql mariadb mariadb-client --no-cache

# remove package caches
rm -rf /var/cache/apk/*

# install default databases
mysql_install_db --user=mysql

# cover default mariadb config
cp /opt/my.conf /etc/mysql/my.conf

# set mysql startup script
cp /usr/share/mysql/mysql.server /etc/init.d/

# start mariadb
/etc/init.d/mysql.server start


# init mail service database
mysqladmin create mail
mysql < /opt/postfix.sql

# create new database & set root password
mysqladmin -u root -h localhost password 'A-Default-Random-Password'

# end
echo "install deps end."
