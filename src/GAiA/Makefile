#
# Makefile for UNIfw1doc
#

VERSION		= 1.0
RELEASE		= 13

COMPILEHOST	= rhes3.ssi.i2.dk
HOSTNAME	= `hostname`

TARGETDIR	= /lan/ssi/shared/software/internal/UNIfw1doc
WORKDIR		= $(TARGETDIR)/src/GAiA

ROOTDIR		= $(WORKDIR)/UNIfw1doc_rootdir
GROUP		= root
NAME		= UNIfw1doc

ARCH		= i386
REDHAT		= /usr/src/redhat
BUILDDIR	= $(REDHAT)/RPMS/$(ARCH)/
SPFILE		= UNIfw1doc-$(VERSION)-$(RELEASE).spec
SPTEMPLATE	= unifw1doc.spec.template
SPECFILE	= $(REDHAT)/SPECS/$(SPFILE)
RPMBR		= /tmp/UNIfw1doc_rootdir

TARGET		= $(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm
INSTALL		= INSTALL-$(NAME)-$(VERSION)-$(RELEASE).md
INST_HTML   = INSTALL-$(NAME)-$(VERSION)-$(RELEASE).html

RPMDIR		= ../../RPM

BR			= UNIfw1doc_rootdir
PREFIX		= $(BR)/var/opt/UNIfw1doc
DIRS		= $(BR)/etc/cron.d $(PREFIX)/log $(PREFIX)/tmp $(PREFIX)/tmp/rundir $(PREFIX)/CPrules $(PREFIX)/cp_webviz_tool $(PREFIX)/html $(PREFIX)/cpdb2web $(PREFIX)/bin $(PREFIX)/etc $(PREFIX)/docs

binfiles	= add-fwadmin.sh genpass install.sh ipropr mkfwdoc add_enforcement_module.sh
etcfiles	= enforcement_modules.lst	etc-cron.d-UNIfw1doc  fw1doc  htmlhead.txt  mkfwdoc.prefs httpd2.conf.tmpl

files		= $(binfiles) $(etcfiles)

all: $(TARGET)
	@echo "made $@"
	@echo "RPM: $(RPMDIR)/$(TARGET)"
	@echo "rpm content: rpm -lpq $(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm"
	@echo "rpm install: rpm -Uvh $(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm"

$(TARGET): $(INSTALL) $(SPECFILE) Makefile $(files)
	$(MAKE) setup
	@rpmbuild -bb --buildroot=$(RPMBR) $(SPFILE)
	@mv $(BUILDDIR)/$(NAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm .
	@/bin/rm -f $(TARGETDIR)/$(TARGET) $(TARGETDIR)/$(INSTALL)
	@/bin/rm -f $(RPMDIR)/$(TARGET) $(RPMDIR)/$(INSTALL)
	mv $(INSTALL) $(RPMDIR)/
	mv $(TARGET) $(RPMDIR)/

setup: $(files) $(INSTALL)
	@mkdir -p $(DIRS)
	@chmod 0755 `find $(BR) -type d`
	@install -g root -o root -m 766 $(etcfiles)     $(PREFIX)/etc/
	@install -g root -o root -m 555 $(binfiles)     $(PREFIX)/bin/
	@install -g root -o root -m 555 $(INSTALL)     $(PREFIX)/docs/
	#@rsync -azH external_precompiled/ $(PREFIX)/
	@echo "made $@"

$(INSTALL): INSTALL.md
	@sed "									\
		s/__VERSION__/$(VERSION)/g;			\
		s/__RELEASE__/$(RELEASE)/g;			\
		s%__TARGET__%$(TARGET)%g;			\
		s%__NAME__%$(NAME)%g;			\
		" < INSTALL.md > $(INSTALL)

$(INST_HTML): $(INSTALL)
	mkd2html -css UNIfw1doc-documentation/assets/CSS/i2-Book.css $(INSTALL)

$(SPECFILE):
	@sed "									\
		s/__VERSION__/$(VERSION)/g;			\
		s/__RELEASE__/$(RELEASE)/g;			\
		s%__ROOTDIR__%$(ROOTDIR)%g;			\
		" < $(SPTEMPLATE)  > $(SPFILE)
	@echo $@ done
	

