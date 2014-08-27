#!/bin/sh

mysql -h mysql -u root -p${MYSQL_ROOT_PASSWORD} <<END_SQL
CREATE DATABASE IF NOT EXISTS glance;

GRANT ALL PRIVILEGES
	ON glance.*
	TO 'glance'@'%'
	IDENTIFIED BY '${GLANCE_DB_PASS}';
END_SQL

