#
# Proto spec for UNIfw1doc
#
# $Header$
#

AutoReqProv: no

Requires: UNItools

%define defaultbuildroot /
# Do not try autogenerate prereq/conflicts/obsoletes and check files
%undefine __check_files
%undefine __find_prereq
%undefine __find_conflicts
%undefine __find_obsoletes
# Be sure buildpolicy set to do nothing
%define __spec_install_post %{nil}
# Something that need for rpm-4.1
%define _missing_doc_files_terminate_build 0

%define name    UNIfw1doc
%define version 1.0
%define release 13

Summary: Utility for check firewall firewall and nat rule
Name: %{name}
Version: %{version}
Release: %{release}
License: GPL
Group: root
Packager: Niels Thomas Haugaard, nth@i2.dk

%description
Check and visualize changes to firewall and NAT rules in for GaIA, R76 and R77*

# Everything is installed 'by hand' below UNIfw1doc_rootdir
%prep
ln -s /lan/ssi/shared/software/internal/UNIfw1doc/src/GAiA/UNIfw1doc_rootdir /tmp/UNIfw1doc_rootdir

%clean
rm /tmp/UNIfw1doc_rootdir

################################################################################

%pre
# Just before the upgrade/install
if [ "$1" = "1" ]; then
	echo "pre: Performing tasks to prepare for the initial installation ... "

	if [ -e /bin/clish ]; then
		echo "OS is GAiA ... good"
		CPOSVER=GAIA
	else
		echo "OS is Secure Platform ... ok"
		CPOSVER=SPLAT
	fi

	if [ -e /etc/init.d/fw1doc ]; then
		echo "stopping existing UNIfw1doc ... "
		/etc/init.d/fw1doc stop
		chkconfig --del fw1doc
	fi
	if [ -e /etc/cron.d/UNIfw1doc ]; then
		echo "removing existing cron entry for UNIfw1doc ... "
		/bin/rm -f /etc/cron.d/fw1doc
		/etc/init.d/crond restart >/dev/null 2>&1
	fi

elif [ "$1" = "2" ]; then
	echo "pre: Perform whatever maintenance must occur before the upgrade begins ... "
	NOW=`/bin/date +%Y-%m-%d`
	mkdir /var/tmp/${NOW}
	cp /var/opt/UNIfw1doc/etc/*			/var/tmp/${NOW}/
	echo "Old config files saved in /var/tmp/${NOW}/"

	if [ -e /etc/init.d/fw1doc ]; then
		echo "stopping existing UNIfw1doc ... "
		/etc/init.d/fw1doc stop
	fi
	if [ -e /etc/cron.d/fw1doc ]; then
		echo "removing existing cron entry for UNIfw1doc ... "
		/bin/rm -f /etc/cron.d/fw1doc
		/etc/init.d/crond restart >/dev/null 2>&1
	fi
fi

# post install script -- just before %files
%post
# Just after the upgrade/install
if [ "$1" = "1" ]; then
	echo "post: Perform tasks for for the initial installation ... "
	/var/opt/UNIfw1doc/bin/install.sh
elif [ "$1" = "2" ]; then
	echo "post: Perform whatever maintenance must occur after the upgrade has ended ... "
	NOW=`/bin/date +%Y-%m-%d`
	echo "Existing config files saved as /var/opt/UNIfw1doc/etc/${NOW}/"
	/bin/mv /var/tmp/${NOW}/ /var/opt/UNIfw1doc/etc/${NOW}/
	for CFG in enforcement_modules.lst mkfwdoc.prefs httpd2.conf
	do
		/bin/cp  /var/opt/UNIfw1doc/etc/${NOW}/${CFG} /var/opt/UNIfw1doc/etc/
	done
	echo "post: Please compare with the new ones"
	echo "post: updating config files ... "
	/var/opt/UNIfw1doc/etc/fw1doc setup
	/etc/init.d/fw1doc start
fi

# pre uninstall script
%preun
if [ "$1" = "1" ]; then
	# upgrade
	echo "pre uninstall: upgradeing ... "

elif [ "$1" = "0" ]; then
	# remove
	echo "pre uninstall: removing ... "

	if [ -e /etc/init.d/fw1doc ]; then
		echo "stopping existing UNIfw1doc ... "
		/etc/init.d/fw1doc stop
		chkconfig --del fw1doc
		/bin/rm /etc/init.d/fw1doc
	fi
	if [ -e /etc/cron.d/fw1doc ]; then
		echo "removing existing cron entry for UNIfw1doc ... "
		/bin/rm -f /etc/cron.d/fw1doc
		/etc/init.d/crond restart >/dev/null 2>&1
	fi
	if [ -f /var/opt/UNIfw1doc/etc/mkfwdoc.prefs ]; then
		ADMIN=`sed '/ADMIN=/!d; s/ADMIN=//' /var/opt/UNIfw1doc/etc/mkfwdoc.prefs`
		echo "Please remove everything left in /var/opt/UNIfw1doc and delete the admin user '${ADMIN:="i2audit"}' used by UNIfw1doc"
	else
		echo "Please remove everything left in /var/opt/UNIfw1doc. Also delete whatever pointed to by /var/opt/UNIfw1doc/data"
	fi
fi

# All files below here - special care regarding upgrade for the config files
%files
/var/opt/UNIfw1doc

# config files deliberately not added here. They will not be wiped upon un-installation
# as they are not part of the installation package
#%config /etc/cron.d/UNIfw1doc
#%config /var/opt/UNIfw1doc/etc/httpd2.conf
#%config /var/opt/UNIfw1doc/etc/.listen_ip.txt
