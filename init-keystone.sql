CREATE DATABASE IF NOT EXISTS keystone;

GRANT ALL PRIVILEGES
	ON keystone.*
	TO 'keystone'@'%'
	IDENTIFIED BY 'supersecret';
