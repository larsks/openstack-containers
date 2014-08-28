#!/bin/sh

mysql -h mysql -u root -p${MYSQL_ROOT_PASSWORD} <<END_SQL
CREATE DATABASE IF NOT EXISTS nova;

GRANT ALL PRIVILEGES
	ON nova.*
	TO 'nova'@'%'
	IDENTIFIED BY '${NOVA_DB_PASS}';
END_SQL

