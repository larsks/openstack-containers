#!/bin/sh

: ${HEAT_KEYSTONE_PASS:=secret}
: ${KEYSTONE_ADMIN_PASS:=secret}

logfile=/var/log/setup-heat

. /root/keystonerc

export OS_PASSWORD=$KEYSTONE_ADMIN_PASS

cat <<EOF
======================================================================
Setting up heat in keystone
======================================================================

EOF

set -e

sh /root/add-keystone-service.sh \
	heat orchestration 'http://heat:8004/v1/%(tenant_id)s'

if ! keystone user-list | grep -q heat; then
echo "Creating heat user."
keystone user-create --name heat --tenant services --pass $HEAT_KEYSTONE_PASS >>$logfile
fi

echo "Assigning heat user to admin role."
if ! keystone user-role-list --tenant services --user heat | grep -q admin; then
keystone user-role-add --user heat --role admin --tenant services >>$logfile
fi

if keystone user-role-list --tenant services --user heat | grep -q _member_; then
keystone user-role-remove --user heat --role _member_ --tenant services >>$logfile
fi

cat <<EOF

All done.
======================================================================
EOF

