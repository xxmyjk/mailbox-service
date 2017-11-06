#!/bin/sh

echo "========= Basic Package Install Start ========="
# set apk repo
apk update

# install deps
apk add postfix postfix-mysql dovecot dovecot-mysql mariadb mariadb-client --no-cache

# remove package caches
rm -rf /var/cache/apk/*
echo "========= Basic Package Install End ========="

echo "\n\n"

echo "========= Mysql Config Start ========="
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
echo "========= Mysql Config End ========="

echo "\n\n"

echo "========= Merge Postfix Config Start ========="
# cover default postfix config
cp /opt/*.cf /etc/postfix/

# settings
#adduser -D -h /home/vmail -u 5000 vmail vmail

postconf -e 'myhostname = mail.xman.legal'
postconf -e 'mydestination = localhost, localhost.localdomain'
postconf -e 'mynetworks = 127.0.0.0/8'
postconf -e 'inet_interfaces = all'
postconf -e 'message_size_limit = 30720000'
postconf -e 'virtual_alias_domains ='
postconf -e 'virtual_alias_maps = proxy:mysql:/etc/postfix/mysql-virtual_forwardings.cf, mysql:/etc/postfix/mysql-virtual_email2email.cf'
postconf -e 'virtual_mailbox_domains = proxy:mysql:/etc/postfix/mysql-virtual_domains.cf'
postconf -e 'virtual_mailbox_maps = proxy:mysql:/etc/postfix/mysql-virtual_mailboxes.cf'
postconf -e 'virtual_mailbox_base = /home/vmail'
postconf -e 'virtual_uid_maps = static:5000'
postconf -e 'virtual_gid_maps = static:5000'
postconf -e 'smtpd_sasl_type = dovecot'
postconf -e 'smtpd_sasl_path = private/auth'
postconf -e 'smtpd_sasl_auth_enable = yes'
postconf -e 'broken_sasl_auth_clients = yes'
postconf -e 'smtpd_sasl_authenticated_header = yes'
postconf -e 'smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
postconf -e 'smtpd_use_tls = yes'
postconf -e 'smtpd_tls_cert_file = /etc/pki/dovecot/certs/dovecot.pem'
postconf -e 'smtpd_tls_key_file = /etc/pki/dovecot/private/dovecot.pem'
postconf -e 'virtual_create_maildirsize = yes'
postconf -e 'virtual_maildir_extended = yes'
postconf -e 'proxy_read_maps = $local_recipient_maps $mydestination $virtual_alias_maps $virtual_alias_domains $virtual_mailbox_maps $virtual_mailbox_domains $relay_recipient_maps $relay_domains $canonical_maps $sender_canonical_maps $recipient_canonical_maps $relocated_maps $transport_maps $mynetworks $virtual_mailbox_limit_maps'
postconf -e 'virtual_transport = dovecot'
postconf -e 'dovecot_destination_recipient_limit = 1'


echo "========= Merge Postfix Config End ========="

echo "\n\n"

echo "========= Merge Dovecot Config Start ========="
# cover default dovecot config
cp /opt/dovecot* /etc/dovecot/
echo "========= Merge Dovecot Config End ========="

echo "\n\n"

echo "========= Modify Runtime User Start ========="
chown -R postfix:postfix /etc/postfix
chown -R dovecot:dovecot /etc/dovecot
echo "========= Modify Runtime User End ========="

echo "\n\n"
