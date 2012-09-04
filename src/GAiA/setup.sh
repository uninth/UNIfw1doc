#!/var/opt/UNItools/bin/bash
#
#
# Copyright (c) 2001-12 NTH. All Rights Reserved
#

#
# Vars
#
CRONFILE=/etc/cron.d/UNIfw1doc
MYDIR=/var/opt/UNIfw1doc
LOGDIRBASE=`df -P $FWDIR/log|awk '$1 != "Filesystem" { print $NF }'`
DATADIR=$LOGDIRBASE/UNIfw1doc/data
CP_HTTPD_CFG=$MYDIR/etc/cp_httpd.conf
RC_FILE=$MYDIR/etc/fw1doc

function do_install()
{
	cat << EOF #> ${CRONFILE}
# document changes to firewall rulebases
59 23 * * * root [ -x /var/opt/UNIfw1doc/bin/mkfwdoc ] && /var/opt/UNIfw1doc/bin/mkfwdoc ifchanges
EOF

	chmod 640	${CRONFILE}
	echo "made file	${CRONFILE}"

	if [ -f ${CP_HTTPD_CFG} ]; then
		echo "Warning:	existing file '${CP_HTTPD_CFG}' wil be changed"
		CPIP=`sed "/ADDRESS=/!d; s/ADDRESS=//;" ${CP_HTTPD_CFG}`
	fi
	while :;
	do
		echo "The web-server needs to be started on a specific IP address."
		echo "The address will only be used in the configuration file '${CP_HTTPD_CFG}'."
		echo 
		echo "Listening ipaddr in ${CP_HTTPD_CFG} is $CPIP"
		echo 
		echo "Please choose an internal IP address from the list:"

		IIF=`netstat -rn|sed -r '/Destination/d; /Kernel/d; /^0.0.0.0/d; /^192.168|172|10/!d' | awk '{ print $NF }'`

		for f in $IIF
		do
			IP=`ifconfig $f |
				egrep 'Link|inet addr'|
					sed '
						 /inet6/d;
						s/Link.*//;
						s/inet addr://;
						s/Bcast.*//;
						 /^lo/d;
						 /127.0.0.1/d;
						 /^sit/d '`
			echo  $IP
		done
		# IP=`echo $IP |awk '{ print $NF }'`
		IP=$CPIP

		$echo $N "Please specify IP address [$IP] $C"
		read LINE
		case $LINE in
			"")	:
			;;
			*)	IP=$LINE
			;;
		esac

		$echo $N "There is no check of your answer. Is it ok to use address    $IP ? [yes] $C"
		read ANS
		case $ANS in
			[JjYy]*|"")
			break
			;;
			*)
			;;
		esac
	done

	# 
	# p12 document made during installation of cp, moves with cp version(s)
	# 
	DEFAULT_SERVCERT=/opt/CPportal-R76/portal/httpdcert/httpdcert.p12

	if [ -f $DEFAULT_SERVCERT ]; then
		SERVCERT=$DEFAULT_SERVCERT
		echo "Using SERVCERT=$DEFAULT_SERVCERT"
	else
		echo "$DEFAULT_SERVCERT not found, searching ... "
		SERVCERT=`find /opt -follow -name 'httpdcert.p12' | head -1`
		if [ -f $SERVCERT ]; then
			echo "using $SERVCERT"
		else
			echo "no httpdcert.p12 found, you are in deep shit, sorry the {CP_HTTPD_CFG} will fail"
		fi
	fi

	echo "Please check ${CP_HTTPD_CFG} if the web-server fails to start"

	cat <<- EOF > ${CP_HTTPD_CFG}
	ACTIVE=1
	ADDRESS=$IP
	PORT=6789
	SSL=1
	WEBROOT=$DATADIR
	SERVCERT=$SERVCERT
	CERTPWD=
	LOGDIR=${MYDIR}/log
	TEMPDIR=${MYDIR}/tmp
EOF
	echo "made file	${CP_HTTPD_CFG}"

	echo "installing start-up scripts in /etc/init.d .. "
	# init.d
	/bin/cp $RC_FILE /etc/init.d
	chkconfig --del `basename $RC_FILE`
	chkconfig --add `basename $RC_FILE`
	chkconfig --list `basename $RC_FILE`

	echo "stopping service -- ignore any errors"
	/etc/init.d/`basename $RC_FILE` stop
	echo "starting service -- do not ignore errors"
	/etc/init.d/`basename $RC_FILE` start
	/etc/init.d/`basename $RC_FILE` status

	#
	# Now polute HTML with data
	#

}

function do_uninstall()
{
	/etc/init.d/`basename $RC_FILE` stop
	chkconfig --del `basename $RC_FILE`
	/bin/rm -f /etc/init.d/`basename $RC_FILE`
}


################################################################################
#
# Main
#
################################################################################
echo=/bin/echo
case ${N}$C in
	"") if $echo "\c" | grep c >/dev/null 2>&1; then
		N='-n'
	else
		C='\c'
	fi ;;
esac


case $1 in
	install)
		do_install
	;;
	uninstall)
		do_uninstall
	;;
	*)	echo "$0 install | uninstall"
	;;
esac

exit 0

