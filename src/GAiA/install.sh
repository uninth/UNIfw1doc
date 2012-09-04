#!/bin/sh
#
# Copyright (c) 2012 UNI-C, NTH. All Rights Reserved
#

DIR=/var/opt/UNIfw1doc

/var/opt/UNIfw1doc/etc/fw1doc setup
LISTEN_IP=`sed '/^Listen.*:6789/!d; s/^.* //; s/:.*//' /var/opt/UNIfw1doc/etc/httpd2.conf`

cat << 'EOF' | sed "s/_LISTEN_IP_/$LISTEN_IP/g"

  * The web-server is started from ``/etc/init.d/fw1doc`` which also creates a
    default httpd2.conf config file with ``Listen`` set to ``127.0.0.1``. You
    will have to change that. The file ``/etc/cron.d/fw1doc`` is also made by
    ``/etc/init.d/fw1doc`` in case it doesn't exist. The service is not started
    by the rpm installation.

## Required actions:

1. The package has to be configured after installation, unless this is an __upgrade__. See 
   the documentation in /var/opt/UNIfw1doc/docs/

   * First, stop all CPMI connections (fwgui).

   * Then, add an __administrator__ (required__ for ``cpdb2web`` to work), and add
     credentials to ``/var/opt/UNIfw1doc/etc/mkfwdoc.prefs``:

	      /var/opt/UNIfw1doc/bin/add-fwadmin.sh

	* Add modules to ``/var/opt/UNIfw1doc/etc/enforcement_modules.lst``, one 
	  line each.  On a stand-alone system, add _hostname_ or ``127.0.0.1``, on a cluster add
	  both enforcement module names or IP addresses.

    Use 

         /var/opt/UNIfw1doc/bin/add_enforcement_module.sh module-address
    
    To enable login with _ssh-keys_ and add the module-address to the config file.

  * Next change the IP address of the web-server in the configuration file
    ``/var/opt/UNIfw1doc/etc/httpd2.conf``. The default address is ``127.0.0.1``.

	This UNIfw1doc has been configured to use the listen address _LISTEN_IP_

  * Then make a first run of the documentation service by executing the command:

		 /var/opt/UNIfw1doc/bin/mkfwdoc -f -v

  * Finally start the web-server with

      /etc/init.d/fw1doc start

In case of error(s) consult the documentation.

EOF
