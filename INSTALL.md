
$Header: /lan/ssi/shared/software/internal/UNIfw1doc/src/GaIA/INSTALL.md,v 1.1 2014/03/17 22:36:54 root Exp $

How to install UNIfw1doc ver 1.0 on GaIA R77.10

Prerequisite
============
Install UNItools first, as perl is needed.

Installation
============
Copy UNIfw1doc-R77.10.GaIA-1.0.i386.rpm to target host (management station).

scp UNIfw1doc-R77.10.GaIA-1.0.i386.rpm ...

Install with
	rpm install: rpm --nodeps -Uvh UNIfw1doc-R77.10.GaIA-1.0.i386.rpm

Create an Check Point Webserver configuration for the web-server part.

	/var/opt/UNIfw1doc/bin/setup.sh install

Select the most suitable IP address for the web-server

Check that the server is running:

	/etc/init.d/fw1log status

If not have a look at the parameters in the config file for the webserver
	/var/opt/UNIfw1doc/etc/cp_httpd.conf

Uninstallation
==============
Remove the package with:

	rpm -e --nodeps UNIfw1doc-R77.10.GaIA-1.0.i386.rpm

