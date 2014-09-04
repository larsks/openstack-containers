#!/bin/sh

mysql -h mysql -u root -p${MYSQL_ROOT_PASSWORD} <<END_SQL
CREATE DATABASE IF NOT EXISTS heat;

GRANT ALL PRIVILEGES
	ON heat.*
	TO 'heat'@'%'
	IDENTIFIED BY '${HEAT_DB_PASS}';
END_SQL

