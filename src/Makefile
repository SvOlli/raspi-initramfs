
BUSYBOX_DIR = busybox
BUSYBOX_VARIANT = busybox
BASEROOT = ../base

all: $(BUSYBOX_DIR)

$(BUSYBOX_DIR):
	git clone git://busybox.net/busybox.git $(BUSYBOX_DIR)
	cp busybox.config $(BUSYBOX_DIR)/.config
	make -C $(BUSYBOX_DIR) oldconfig

$(BUSYBOX_DIR)/$(BUSYBOX_VARIANT): $(BUSYBOX_DIR)
	make -C $(BUSYBOX_DIR) $(BUSYBOX_VARIANT)

install: $(BUSYBOX_DIR)/$(BUSYBOX_VARIANT)
	install -D $(BUSYBOX_DIR)/$(BUSYBOX_VARIANT) $(BASEROOT)/bin/busybox

