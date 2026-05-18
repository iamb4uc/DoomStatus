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

all: DoomStatus

$(COM:=.o): config.mk $(REQ:=.h)
DoomStatus.o: DoomStatus.c DoomStatus.h arg.h config.h config.mk $(REQ:=.h)

.c.o:
	$(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $<

config.h:
	cp config.def.h $@

DoomStatus: DoomStatus.o $(COM:=.o) $(REQ:=.o)
	$(CC) -o $@ $(LDFLAGS) $(COM:=.o) $(REQ:=.o) DoomStatus.o $(LDLIBS)

clean:
	rm -f DoomStatus DoomStatus.o $(COM:=.o) $(REQ:=.o)

dist:
	rm -rf "DoomStatus-$(VERSION)"
	mkdir -p "DoomStatus-$(VERSION)/components"
	cp -R LICENSE Makefile README config.mk config.def.h \
	      arg.h DoomStatus.c $(COM:=.c) $(REQ:=.c) $(REQ:=.h) \
	      DoomStatus.1 "DoomStatus-$(VERSION)"
	tar -cf - "DoomStatus-$(VERSION)" | gzip -c > "DoomStatus-$(VERSION).tar.gz"
	rm -rf "DoomStatus-$(VERSION)"

install: all
	mkdir -p "$(DESTDIR)$(PREFIX)/bin"
	cp -f DoomStatus "$(DESTDIR)$(PREFIX)/bin"
	chmod 755 "$(DESTDIR)$(PREFIX)/bin/DoomStatus"
	mkdir -p "$(DESTDIR)$(MANPREFIX)/man1"
	cp -f DoomStatus.1 "$(DESTDIR)$(MANPREFIX)/man1"
	chmod 644 "$(DESTDIR)$(MANPREFIX)/man1/DoomStatus.1"

uninstall:
	rm -f "$(DESTDIR)$(PREFIX)/bin/DoomStatus"
	rm -f "$(DESTDIR)$(MANPREFIX)/man1/DoomStatus.1"
