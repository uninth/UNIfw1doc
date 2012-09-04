#!/bin/sh
#
# Copyright (c) 2012 UNI-C, NTH. All Rights Reserved

genpasswd() {
	local l=$1
		[ "$l" == "" ] && l=20
		tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}


U=i2audit
P=`genpasswd 8`

cat << EOF
The following requires all CPMI connections to be closed
--------------------------------------------------------
Adding fwmuses administrator and modifying firewall_properties:
Administrator: $U
Password:      $P
Permissions:   Read all

dbedit: modify properties firewall_properties allow_only_single_cpconfig_admin false
fwm -a $U -s $P -wr

Updating /var/opt/UNIfw1doc/etc/mkfwdoc.prefs

EOF

TMPFILE=$(mktemp)

cat << EOF > $TMPFILE
modify properties firewall_properties allow_only_single_cpconfig_admin false
quit -update_all
EOF

dbedit -s localhost -f $TMPFILE
case $? in
	0)	echo done
	;;
	*)	
echo "If update fails, please execute 'dbedit -s localhost'"
echo modify properties firewall_properties allow_only_single_cpconfig_admin false
echo quit -update_all
	;;
esac

/bin/rm -f /tmp/cmd

# remove existing
sed "/^$U/d" $FWDIR/conf/fwmusers > /tmp/fwmusers && /bin/cp /tmp/fwmusers $FWDIR/conf/fwmusers
fwm -a $U -s $P -wr
case $? in
	0) echo "user $U added to \$FWDIR/conf/fwmusers"
	;;
	*) echo "failed to add $U to \$FWDIR/conf/fwmusers"
	   echo "Re-run command after closing all CPMI connections:"
	   echo "Manually remove existing $U user:"
	   echo "sed '/^$U/d' $FWDIR/conf/fwmusers > /tmp/fwmusers && /bin/cp /tmp/fwmusers $FWDIR/conf/fwmusers"
	   echo "followed by:"
	   echo "fwm -a $U -s $P -wr"
	;;
esac

cat << EOF > /var/opt/UNIfw1doc/etc/mkfwdoc.prefs
ADMIN=$U
ADMPW=$P
EOF
