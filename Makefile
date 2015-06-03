############################################################
# <bsn.cl fy=2013 v=none>
#
#        Copyright 2013, 2014 BigSwitch Networks, Inc.
#
#
#
# </bsn.cl>
############################################################
#
# ONL base buildroot cpio.
#
############################################################
include $(ONL)/make/config.powerpc.mk

#
# We build for these architectures
#
ARCHS := powerpc x86_64
BUILDROOT_ARCHDIRS := $(foreach a,$(ARCHS),buildroot-$(a))

.PHONY: all clean setup $(BUILDROOT_ARCHDIRS)

all: setup $(BUILDROOT_ARCHDIRS)

clean:
	rm -rf $(BUILDROOT_ARCHDIRS)


setup:
	cp $(wildcard patches/busybox*.patch) buildroot/package/busybox/
	cp $(wildcard patches/kexec*.patch) buildroot/package/kexec/
	sed -i 's%^DOSFSTOOLS_SITE =.*%DOSFSTOOLS_SITE = http://downloads.openwrt.org/sources%' buildroot/package/dosfstools/dosfstools.mk
	sed -i 's%^UEMACS_SITE =.*%UEMACS_SITE = http://www.kernel.org/pub/linux/kernel/uemacs%;s%^UEMACS_SOURCE =.*%UEMACS_SOURCE = em-$$(UEMACS_VERSION).tar.gz%' buildroot/package/uemacs/uemacs.mk
	mkdir -p buildroot/package/jq
	cp patches/jq.mk buildroot/package/jq/jq.mk
	cp patches/jq.Config.in buildroot/package/jq/Config.in
	sed -i '/[/]jq[/]/d' buildroot/package/Config.in
	sed -i '/[/]yajl[/]/a\source "package/jq/Config.in"' buildroot/package/Config.in
	mkdir -p $(BUILDROOT_ARCHDIRS)
	$(foreach a,$(ARCHS),cp buildroot.config-$(a) buildroot-$(a)/.config ;)


define buildroot_arch
buildroot-$(1):
	make -C buildroot O=../buildroot-$(1)

buildroot-menuconfig-$(1):
	make -C buildroot menuconfig O=../buildroot-$(1)
	cp buildroot-powerpc/.config buildroot.config-$(1)
endef

$(foreach a,$(ARCHS),$(eval $(call buildroot_arch,$(a))))

busybox-menuconfig:
	make -C buildroot busybox-menuconfig O=../buildroot-powerpc
	cp buildroot-powerpc/build/busybox-*/.config busybox.config
