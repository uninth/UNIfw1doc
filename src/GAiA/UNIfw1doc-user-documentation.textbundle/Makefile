#
# Makefile til UNIfw1doc dokumentation
#
rev = "$Revision: 1.2 $"

css	=	assets/CSS/GitHub-ReadMe.css
css	=	assets/CSS/i2-Book.css

wkhtmltopdf = wkhtmltopdf
pdfunite	= pdfunite

#
# wkhtmltopdf cannot be ported to rhes3 (RHES3) but is installed on office.ssi.i2.dk, so the
# documentation should be made there
#

all: bundle UNIfw1doc.pdf

bundle: UNIfw1doc.html
	/bin/rm -fr UNIfw1doc-documentation
	mkdir UNIfw1doc-documentation
	cp -r UNIfw1doc.html assets UNIfw1doc-documentation
	@tar cvfpz UNIfw1doc-doc.tgz UNIfw1doc-documentation
	/bin/rm -fr UNIfw1doc-documentation
	ls -l UNIfw1doc-doc.tgz

UNIfw1doc.html: UNIfw1doc.md Makefile
	@./mk.sh $(css) UNIfw1doc.md > UNIfw1doc.html

UNIfw1doc-body.pdf: UNIfw1doc.md UNIfw1doc.html
	$(wkhtmltopdf) toc UNIfw1doc.html --footer-line --enable-internal-links --footer-spacing 2 --footer-right 'page [page] of [topage]'  UNIfw1doc-body.pdf

UNIfw1doc.pdf: coverpage.pdf UNIfw1doc-body.pdf Makefile
	$(pdfunite) coverpage.pdf UNIfw1doc-body.pdf UNIfw1doc.pdf
