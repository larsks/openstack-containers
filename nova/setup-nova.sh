#!/bin/sh

: ${NOVA_KEYSTONE_PASS:=secret}
: ${KEYSTONE_ADMIN_PASS:=secret}

logfile=/var/log/setup-nova

. /root/keystonerc

export OS_PASSWORD=$KEYSTONE_ADMIN_PASS

cat <<EOF
======================================================================
Setting up nova in keystone
======================================================================

EOF

set -e

sh /root/add-keystone-service.sh \
	nova compute 'http://nova:8774/v2/%(tenant_id)s'

if ! keystone user-list | grep -q nova; then
echo "Creating nova user."
keystone user-create --name nova --tenant services --pass $NOVA_KEYSTONE_PASS >>$logfile
fi

echo "Assigning nova user to admin role."
if ! keystone user-role-list --tenant services --user nova | grep -q admin; then
keystone user-role-add --user nova --role admin --tenant services >>$logfile
fi

if keystone user-role-list --tenant services --user nova | grep -q _member_; then
keystone user-role-remove --user nova --role _member_ --tenant services >>$logfile
fi

cat <<EOF

All done.
======================================================================
EOF

