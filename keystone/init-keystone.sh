#!/bin/sh

mysql -h mysql -u root -p${MYSQL_ROOT_PASSWORD} <<END_SQL
CREATE DATABASE IF NOT EXISTS keystone;

GRANT ALL PRIVILEGES
	ON keystone.*
	TO 'keystone'@'%'
	IDENTIFIED BY '${KEYSTONE_DB_PASS}';
END_SQL

