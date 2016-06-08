
BASEROOT = ../base

BUSYBOX_DIR = busybox
BUSYBOX_VARIANT = busybox

DROPBEAR_DIR = dropbear

all: $(BUSYBOX_DIR)

$(BUSYBOX_DIR):
	git clone git://busybox.net/busybox.git $(BUSYBOX_DIR)
	cp busybox.config $(BUSYBOX_DIR)/.config
	make -C $(BUSYBOX_DIR) oldconfig

$(BUSYBOX_DIR)/$(BUSYBOX_VARIANT): $(BUSYBOX_DIR)
	make -C $(BUSYBOX_DIR) $(BUSYBOX_VARIANT)

$(DROPBEAR_DIR):
	git clone git://github.com/mkj/dropbear.git $(DROPBEAR_DIR)
	cd $(DROPBEAR_DIR) && autoconf && autoheader

$(DROPBEAR_DIR)/build: $(DROPBEAR_DIR)
	mkdir $(DROPBEAR_DIR)/build
	cd $(DROPBEAR_DIR)/build && ../configure --prefix=/usr --disable-pam --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx --disable-loginfunc --disable-pututline --disable-pututxline

$(DROPBEAR_DIR)/build/dropbearmulti: $(DROPBEAR_DIR)/build
	make -C $(DROPBEAR_DIR)/build PROGRAMS="dropbear dropbearkey dropbearconvert dbclient scp" MULTI=1 SCPPROGRESS=1

install: $(BUSYBOX_DIR)/$(BUSYBOX_VARIANT) $(DROPBEAR_DIR)/build/dropbearmulti
	install -D $(BUSYBOX_DIR)/$(BUSYBOX_VARIANT) $(BASEROOT)/bin/busybox
	install -D $(DROPBEAR_DIR)/build/dropbearmulti ../dropbear/usr/bin/dropbearmulti

