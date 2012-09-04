
# Installation procedure for UNIfw1doc-1.0-13.i386.rpm

    Package name: UNIfw1doc-1.0-13.i386.rpm
    Version     : 1.0
    Release     : 13

## Prerequisite

Install UNItools first, as perl __may__ be needed. Notice: the package does _not_
check if **UNItools** is installed.

This version of UNIfw1doc-1.0-13.i386.rpm only works with GAiA, not Secure Platform.

  - the web-server configuration requires Apache from GAiA
  - adding multiple  _administrators_ to ``fwmusers`` is not tested and may fail on Secure Platform

## Installation

1. Copy ``UNIfw1doc-1.0-13.i386.rpm`` to the management station (firewall), and install the package

		cd /
        td -x UNIfw1doc-1.0-13.i386.rpm external-interface
        td external-interface
        rpm -Uvh /var/tmp/UNIfw1doc-1.0-13.i386.rpm

1. Creating the documentation require _cpdb2web_ or _CPrules_, which must be
   installed separately. Only one is required.  Check Point cpdb2web may be
   download from
   [supportcenter.checkpoint.com](https://supportcenter.checkpoint.com), search
   for **sk64501** and download R77.x for Gaia / SecurePlatform / Linux. cpdb2web
   does not require a special license. _Download Gaia / SecurePlatform / Linux, R77.x._      
   Create the directory `/var/opt/UNIfw1doc/cp_webviz_tool` and move
   the archive to there. Then unpack it with `tar xvfpz cpdb2web*gz`          
   Notice the documentation created with cpdb2web requires Firefow for best viewing.       
   CPrules may be downloaded from [here](http://www.wormnet.nl/download/CPRules.tar.gz)      
   Create the directory `/var/opt/UNIfw1doc/CPrules`, unpack CPRules.tar.gz and move all files
   to `/var/opt/UNIfw1doc/CPrules`.

1. The package has to be configured afterwards, unless this is an __upgrade__. The
   post installation configuration required actions are:

   * Stop all CPMI connections (fwgui).

   * A new __administrator is required__ for ``cpdb2web`` to work. Read-only all products
     is sufficient. Add credentials to ``/var/opt/UNIfw1doc/etc/mkfwdoc.prefs``.
	 The syntax is

            ADMIN=i2audit
            ADMPW=SomeRandomPassword

     Use

	      /var/opt/UNIfw1doc/bin/add-fwadmin.sh

	  which will create an adminstrator in ``fwmusers`` with read only rights
	  and modify properties firewall_properties to
	  allow_only_single_cpconfig_admin. See script for details.
   
	* Reading the _module state_ (route information and firewall version and H-A status)
	  requires ``ssh`` to work without password. Each firewall module should be listed
	  in ``/var/opt/UNIfw1doc/etc/enforcement_modules.lst``, with one module name for each
	  line.

	  On a stand-alone system, add the _hostname__ or ``127.0.0.1``, on a cluster add both
	  enforcement module names or IP addresses.

	  Use 

	         /var/opt/UNIfw1doc/bin/add_enforcement_module.sh module-address
    
	  To enable login with _ssh-keys_ and add the module-address to the config file.

    * Finally change the IP address of the web-server in the configuration file
      ``/var/opt/UNIfw1doc/etc/httpd2.conf``. The default address is ``127.0.0.1``.

An example configuration file is shown here:

    ACTIVE=1
    ADDRESS=192.168.112.1
    PORT=6789
    SSL=1
    WEBROOT=/var/opt/UNIfw1doc/
    SERVCERT=/opt/CPportal-R77/portal/httpdcert/httpdcert.p12
    CERTPWD=
    LOGDIR=/var/opt/UNIfw1doc/log
    TEMPDIR=/var/opt/UNIfw1doc/tmp

	  Restart the web-server with

	      /etc/init.d/fw1doc restart


The installation _will fail_ with a _warning_ if no **httpdcert.p12** is found. The
file system is search for such a certificate. In that case please make sure the
firewall _management software_ is installed.

Check that the server is running:

	/etc/init.d/fw1doc status

If not have a look at the parameters in the config file for the webserver.



## Uninstallation

Remove the package with:

	rpm -e --nodeps UNIfw1doc

Remove the administrator (``i2audit``) manually. Also, see the section below.

## Note

This document is in RCS and build with ``make``.

## Caveat and uninstallation notes

In a H-A setup ssh **MUST** work with _keys_, otherwise ``ipropr`` will fail ungracefully.

Please check carefully on the remote host, that the local IP address, hostname or ``ALL: ALL`` is
in ``/etc/hosts.allow``.

This is done with the command

    clish -c 'add allowed-client host ipv4-address a.b.c.d'

The firewall configuration was modified by dbedit to allow multiple fwmusers (as this is the
simplest way of adding a firewall administrator from the command line). You may want to reverse
the setting by executing the command:

	dbedit -s localhost
	modify properties firewall_properties allow_only_single_cpconfig_admin false
	quit -update_all

This is currently not done when removing the package.

## RPM info

You may wiew rpm content with

	rpm -q UNIfw1doc


