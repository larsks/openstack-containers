#!/bin/sh

logfile=/var/log/setup-glance

. /root/keystonerc

cat <<EOF
======================================================================
Setting up glance in keystone
======================================================================

EOF

sh /root/add-keystone-service.sh \
	glance image http://glance:9292

if ! keystone user-list | grep -q glance; then
echo "Creating glance user."
keystone user-create --name glance --tenant services --pass secret >>$logfile
fi

echo "Assigning glance user to admin role."
keystone user-role-add --user glance --role admin --tenant services >>$logfile
keystone user-role-remove --user glance --role _member_ --tenant services >>$logfile

cat <<EOF

All done.
======================================================================
EOF

