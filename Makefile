# See LICENSE file for copyright and license details
# DoomStatus - customized suckless status monitor
.POSIX:

include config.mk

REQ = util
COM =\
	components/battery\
	components/cpu\
	components/datetime\
	components/disk\
	components/entropy\
	components/hostname\
	components/ip\
	components/kernel_release\
	components/keyboard_indicators\
	components/keymap\
	components/load_avg\
	components/netspeeds\
	components/num_files\
	components/ram\
	components/run_command\
	components/separator\
	components/swap\
	components/temperature\
	components/uptime\
	components/user\
	components/volume\
	components/wifi

all: doomstatus

$(COM:=.o): config.mk $(REQ:=.h)
doomstatus.o: doomstatus.c doomstatus.h arg.h config.h config.mk $(REQ:=.h)

.c.o:
	$(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $<

config.h:
	cp config.def.h $@

doomstatus: doomstatus.o $(COM:=.o) $(REQ:=.o)
	$(CC) -o $@ $(LDFLAGS) $(COM:=.o) $(REQ:=.o) doomstatus.o $(LDLIBS)

clean:
	rm -f doomstatus doomstatus.o DoomStatus DoomStatus.o $(COM:=.o) $(REQ:=.o)

dist:
	rm -rf "doomstatus-$(VERSION)"
	mkdir -p "doomstatus-$(VERSION)/components"
	cp -R LICENSE Makefile README config.mk config.def.h \
	      arg.h doomstatus.c $(COM:=.c) $(REQ:=.c) $(REQ:=.h) \
	      doomstatus.1 "doomstatus-$(VERSION)"
	tar -cf - "doomstatus-$(VERSION)" | gzip -c > "doomstatus-$(VERSION).tar.gz"
	rm -rf "doomstatus-$(VERSION)"

install: all
	mkdir -p "$(DESTDIR)$(PREFIX)/bin"
	cp -f doomstatus "$(DESTDIR)$(PREFIX)/bin"
	chmod 755 "$(DESTDIR)$(PREFIX)/bin/doomstatus"
	mkdir -p "$(DESTDIR)$(MANPREFIX)/man1"
	cp -f doomstatus.1 "$(DESTDIR)$(MANPREFIX)/man1"
	chmod 644 "$(DESTDIR)$(MANPREFIX)/man1/doomstatus.1"

uninstall:
	rm -f "$(DESTDIR)$(PREFIX)/bin/doomstatus"
	rm -f "$(DESTDIR)$(MANPREFIX)/man1/doomstatus.1"
