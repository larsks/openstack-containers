CREATE DATABASE IF NOT EXISTS glance;

GRANT ALL PRIVILEGES
	ON glance.*
	TO 'glance'@'%'
	IDENTIFIED BY 'supersecret';
