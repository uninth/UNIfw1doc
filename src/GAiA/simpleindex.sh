#!/bin/sh
#
# $Header: /home/uninth/src/simpleindex/simpleindex.sh,v 1.2 2005/06/21 21:16:06 root Exp uninth $
#

#
# Vars
#
VERSION="$Id$"
BASE__DIR=`pwd`
BASE__DIR=`basename $BASE__DIR`
#DATE=`export LANG=da_DK; export LC_TIME=da_DK; date "+%A den %d %B %Y kl. %H:%M"`
DATE=`export LANG=en_US; export LC_TIME=en_US; date "+%A, %B %d %Y at %H:%M"`
MYNAME=`basename $0`
MYNAME=`echo $MYNAME | sed 's/\.[a-z0-9]*$//'`
CFG=/var/opt/UNIfw1doc/etc/${MYNAME}.cfg
MY_CSS=/var/opt/UNIfw1doc/etc/uni_pkg.css
MY_LICENSE=/var/opt/UNIfw1doc/etc/license.html
GENERATOR="${MYNAME}"

CHANGES="changes.tmp"

IGNORE="css icons img scripts"

#
# Functions
#

mungle_sed() {
# purpose     : The real stuff
# arguments   : none
# return value: none
# see also    :

	sed "
	s%__BASE__DIR__%$BASE__DIR%g;
	s%__GENERATOR__%$GENERATOR - $VERSION%g;
	s%__DATE__%$DATE%g;
	"
}

usage() {
# purpose     : Script usage
# arguments   : none
# return value: none
# see also    :
echo $*
cat << EOF
	Usage: `basename $0`
	make a simple index.html page for CWD

	Uses css in $CSS

EOF
	exit 2
}

clean_f () {
# purpose     : Clean-up on trapping (signal)
# arguments   : None
# return value: None
# see also    :
	$echo trapped
	# /bin/rm -f ./index.html
	exit 1
}

#
# clean up on trap(s)
#
trap clean_f 1 2 3 13 15

################################################################################
# Main
################################################################################

echo=/bin/echo
case ${N}$C in
	"") if $echo "\c" | grep c >/dev/null 2>&1; then
		N='-n'
	else
		C='\c'
	fi ;;
esac

#
# Process arguments
#
while getopts cif opt
do
case $opt in
	f)	FORCE=YES
	;;
	*)	usage
		exit
	;;
esac
done
shift `expr $OPTIND - 1`

if [ -f index.html -a "$FORCE" != "YES" ]; then
	echo "filen 'index.html' findes, abort"
	echo "brug /bin/rm index.html, eller kald $0 -f "
	exit 0
fi

if [ -f "$MY_CSS" ]; then

	(
	cat << 'END_OF_HEAD'
<?xml version="1.0" encoding="latin1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
<head>
  <meta name="generator" content="__GENERATOR__" />
  <meta http-equiv="Content-Type" content="text/html; charset=latin1" />

  <title>Index for __BASE__DIR__</title>

END_OF_HEAD

		cat $MY_CSS

		echo '</head>'


	) | mungle_sed > index.html
else
	echo "css fil '$MY_CSS' not found, abort"
	exit 1
fi

if [ ! -f $MY_LICENSE ]; then
	echo "license file '$MY_LICENSE' not found, abort"
	exit 1
fi

if [ -f .info ]; then
	TITLE=`sed "/^TITLE.*:/!d; s/.*://"	.info`
	INFO=`sed "/^INFO.*:/!d; s/.*://"	.info`
	LOGO=`sed "/^LOGO.*:/!d; s/.*://"	.info`
	if [ -n "$LOGO" ]; then
		LOGO_LINE="<IMG SRC=\"$LOGO\" ALT='' align=\"RIGHT\" border=\"0\">"
	fi
fi

cat << EOF | mungle_sed >> index.html
<body>
  <div id="summary" style="border-top: 1px solid #999; border-bottom: 1px solid #999; background-color: #FFF";>
    <h1>${TITLE:="Indeks for __BASE__DIR__"}
    $LOGO_LINE
    </h1>
    <h2>${INFO:="Indeks for __BASE__DIR__"}</h2>
  </div>

  <div id="toc">
    <p><b>Contents</b></p>

    <table summary="toc" style="border:0px;">
	    <tr valign=top>
		    <td><b>Nr</b></td>
		    <td><b>Rulebase name</b></td>
		    <td><b>Installed On/Not installed</b></td>
		    <td><b>Last installation date</b></td>
	    </tr>
EOF

i=1
IGNORE="s/css//; s/icons//; s/img//; s/scripts//;"
for FILE in `echo * | sed "s/index.html//; $IGNORE; s%$LOGO%%"`
do
		#
		# Here are only directories
		#
		i=`echo $i + 1 | bc`
		if [ -d "$FILE" ]; then
			INDEX=$FILE/index.html	# håber den er der !
			INSTALLATION_DATE="Unknown (error 3)"

			if [ -f .info ]; then
				# FILE:TITLE
				TITLE=`sed "/^$FILE:/!d; s/.*://" .info`
				if [ -z "${TITLE}" ]; then
					TITLE="currently unknown (error 1)"
			fi
		else
				TITLE="currently unknown (error 2)"
		fi
	
		cat << EOF >> index.html
	    <tr valign=top>
		    <td align=right>$i.</td>
		    <td><a href="$FILE">$FILE</a></td>
		    <td>${TITLE:="Unknown contents"}</td>
		    <td>$INSTALLATION_DATE</td>
	    </tr>
EOF

		i=`echo $i + 1 | bc`
	fi
:
done

(
cat << 'EOF'
    </table>
  </div>
  <p>
EOF

if [ -f "${CHANGES}" ]; then
	echo "<b>Selected, recorded changes from the audit log</b>"
	cat ${CHANGES}
fi

cat << 'EOF'
</p>
  <div class="disclaimer">
    <span><em>Documentation assembled by <A HREF="http://sikkerhed.uni-c.dk">UNI<FONT COLOR=RED><EM>&middot;</EM></FONT>C</a> __DATE__</em>. Licence and usage <A HREF="license.html">here</a>.</span>
EOF

#
# Make licence
#
(
	cat << 'END_OF_HEAD'
<?xml version="1.0" encoding="latin1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
<head>
  <meta name="generator" content="__GENERATOR__" />
  <meta http-equiv="Content-Type" content="text/html; charset=latin1" />

  <title>Index for __BASE__DIR__</title>

END_OF_HEAD

		cat $MY_CSS

		echo '</head>'
cat $MY_LICENSE 

echo "</body>"
echo "</html>"

) | mungle_sed > ./license.html

chmod 444 ./license.html

cat << 'EOF'
    </div>
  </div>
EOF

echo "</body>"
echo "</html>"
) | mungle_sed >> index.html

chmod 444 index.html

exit 0


