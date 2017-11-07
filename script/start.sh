#!/bin/sh

echo "start mysql service ......"
/etc/init.d/mysql.server start

echo "start postfix ......"
postfix start

echo "start dovecot ......"
dovecot