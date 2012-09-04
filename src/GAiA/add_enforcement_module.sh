#!/bin/sh
#
# Copyright (c) 2012 UNI-C, NTH. All Rights Reserved
#

usage ()
{
	cat <<-EOF

	$0: Add id_dsa.pub to gateway

	Usage:
		$0 gateway

		gateway: IP address or resolvable FQDN.

		Assumes remote user is 'admin'

		$0 will generate id_dsa.pub if not found and set permissions correctly

		When using /etc/hosts.allow on GAiA please add this host with

		clish -c 'add allowed-client host ipv4-address 127.0.0.1'

EOF

	exit 0
}

case $1 in
	"")	usage
	;;
	*)	GW=$1
		echo "This script does *not do anything but printing instructions*"
		echo
		echo "ssh access must be enabled first on ${GW} for the user admin"
		echo
		echo "both in the rulebase and in GAiA:"
		echo
		echo "clish -c 'add allowed-client host ipv4-address ${GW}'"
		echo
		echo "Remember the rulebase also!"
		echo
		sleep 5
	;;
esac

echo "$0 gateway"

exit

# id_dsa.pub must exist on localhost
if [ ! -f $HOME/.ssh/id_dsa.pub ]; then echo | ssh-keygen -b 2048 -t dsa -q -N '' >/dev/null 2>&1; fi

# .ssh must exist on remote host
echo 'if [ ! -f .ssh/id_dsa.pub ]; then echo | ssh-keygen -b 2048 -t dsa -q -N ""; fi 2>&1 >/dev/null ' | ssh admin@${GW}

# append
cat $HOME/.ssh/id_dsa.pub | ssh ${GW} 'cat >> .ssh/authorized_keys; chmod 700 .ssh/authorized_keys'

# check and remove duplicates
ssh ${GW} 'cd .ssh; sort -u authorized_keys > authorized_keys.u && /bin/mv authorized_keys.u authorized_keys; chmod 700 *'

# add GW to /var/opt/UNIfw1doc/etc/enforcement_modules.lst
( echo $GW; cat /var/opt/UNIfw1doc/etc/enforcement_modules.lst; ) | sort -u > /tmp/enforcement_modules.lst
/bin/mv /tmp/enforcement_modules.lst /var/opt/UNIfw1doc/etc/enforcement_modules.lst

echo $GW added to /var/opt/UNIfw1doc/etc/enforcement_modules.lst
echo
echo list:
pr -t -e4 -n /var/opt/UNIfw1doc/etc/enforcement_modules.lst

