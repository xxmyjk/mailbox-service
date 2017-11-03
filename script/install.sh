#!/bin/sh

# start
echo "start install deps ..."

# set apk repo
apk update

# install deps
apk add postfix postfix-mysql dovecot dovecot-mysql mariadb mariadb-client --no-cache

rm -rf /var/cache/apk/*

mysql_install_db --user=mysql

#mysql_secure_installation

#cp /opt/my.conf /etc/mysql/my.conf
cp /usr/share/mysql/mysql.server /etc/init.d/

/etc/init.d/mysql.server start

# test start ..............

#start mysql service here.

# test end ..............

# end
echo "install deps end."
