#!/bin/sh

logfile=/var/log/setup-keystone.log

_keystone () {
	keystone --os-endpoint http://keystone:35357/v2.0 --os-token ADMIN "$@"
}

cat <<EOF
======================================================================
Initializing keystone
======================================================================

EOF

if ! _keystone service-list | grep -q keystone; then
echo "Creating keystone service."
_keystone service-create --name keystone --type identity | tee /tmp/keystone.service >>$logfile
svcid=$(awk '$2 == "id" {print $4}' /tmp/keystone.service)
fi

if ! _keystone endpoint-list | grep -q keystone; then
echo "Creating keystone endpoint."
_keystone endpoint-create --service $svcid \
	--publicurl http://keystone:5000/v2.0 \
	--adminurl http://keystone:35357/v2.0 \
	--internalurl http://keystone:5000/v2.0 >>$logfile
fi

if ! _keystone tenant-list | grep -q admin; then
echo "Creating admin tenant."
_keystone tenant-create --name admin >>$logfile
fi

if ! _keystone role-list | grep -q admin; then
echo "Creating admin role."
_keystone role-create --name admin >>$logfile
fi

if ! _keystone user-list | grep -q admin; then
echo "Creating admin user."
_keystone user-create --name admin --tenant admin --pass secret >>$logfile
fi

echo "Assigning admin user to admin role."
_keystone user-role-add --user admin --role admin --tenant admin >>$logfile

if ! _keystone tenant-list | grep -q services; then
echo "Creating services tenant."
_keystone tenant-create --name services >> $logfile
fi

cat <<EOF

All done.
======================================================================
EOF

