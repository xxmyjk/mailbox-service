-- 创建用户并赋权限
GRANT ALL ON mail.* TO 'mail_admin'@'localhost' IDENTIFIED BY 'XlegalMailService';
FLUSH PRIVILEGES;

-- 虚拟域名表
CREATE TABLE mail.domains (domain varchar(50) NOT NULL, PRIMARY KEY (domain) );

-- 邮件转发
CREATE TABLE mail.forwardings (source varchar(80) NOT NULL, destination TEXT NOT NULL, PRIMARY KEY (source) );

-- 用户表
CREATE TABLE mail.users (email varchar(80) NOT NULL, password varchar(20) NOT NULL, PRIMARY KEY (email) );

-- 传输路径表
CREATE TABLE mail.transport ( domain varchar(128) NOT NULL default '', transport varchar(128) NOT NULL default '', UNIQUE KEY domain (domain) );