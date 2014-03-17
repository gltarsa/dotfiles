#
# Makefile to create various X fonts.
#

# for OpenLook, you must create the .fb files, install them in
# /usr/lib/X11/fonts wht 644 protections, run the command:
#	bldfamily -d /usr/lib/X11/fonts
# then run the command:
#	xset fp rehash
#

#FONTDIR=/usr/new/X11/lib/fonts/misc
FONTDIR=/usr/lib//X11/fonts/misc
FONTS_V4 = gallant.r.19.snf myhand.r.19.snf \
	screen.r.12.snf screen.r.14.snf screen.r.7.snf \
	screen.b.12.snf screen.b.14.snf
FONTS_V5 = gallant.r.19.pcf myhand.r.19.pcf \
	screen.r.12.pcf screen.r.14.pcf screen.r.7.pcf \
	screen.b.12.pcf screen.b.14.pcf
FONTS_OL = gallant.r.19.fb myhand.r.19.fb \
	screen.r.12.fb screen.r.14.fb screen.r.7.fb \
	screen.b.12.fb screen.b.14.fb

FONTS = $(FONTS_V5)

.SUFFIXES: .bdf .snf .pcf .fb

.bdf.fb:
	convertfont -b $*.bdf -o $*.fb

.bdf.snf:
# X11R3 	bdftosnf -t -p4 $*.bdf > $*.snf
	bdftosnf -t $*.bdf > $*.snf

.bdf.pcf:
	bdftopcf -t $*.bdf > $*.pcf

all: $(FONTS) fixnames

fixnames:
#	For some reason, converfont adds the last portion of the filename
# 	twice, and we have to fix it.  Suns OpenLook only.
	@for i in $(FONTS_OL); \
	do \
	    name=`expr $$i : '\(.*\)\.fb'`; \
	    number=`expr $$i : '.*\.\([0-9][0-9]*\)\.fb'`; \
	    test -f $${name}$${number}.fb || continue; \
	    echo fixing by doing mv -f $${name}$${number}.fb $$i; \
	    mv -f $${name}$${number}.fb $$i; \
	done

install:
	-@for i in $(FONTS_V5); \
	do \
	   echo install -f $(FONTDIR) -m 755 $$i; \
	   install -f $(FONTDIR) -m 755 $$i; \
	done
	mkfontdir $(FONTDIR)
	-xset -fp $(FONTDIR)
	-xset +fp $(FONTDIR)

clean:
	rm -f $(FONTS)
