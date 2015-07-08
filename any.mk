# -*- Makefile -*-
############################################################
# <bsn.cl fy=2013 v=onl>
#
#        Copyright 2013, 2014 Big Switch Networks, Inc.
#
# Licensed under the Eclipse Public License, Version 1.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#        http://www.eclipse.org/legal/epl-v10.html
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied. See the License for the specific
# language governing permissions and limitations under the
# License.
#
# </bsn.cl>
############################################################
#
#
############################################################
ifndef ARCH
$(error $$ARCH is not set)
endif

ifndef BUILDROOT_ARCH
BUILDROOT_ARCH := $(ARCH)
endif

ONL_BUILDROOT := $(ONL)/packages/any/buildroot

buildroot-initrd-$(ARCH).cpio.gz: $(ONL_BUILDROOT)/.setup.done
	$(MAKE) -C $(ONL_BUILDROOT) buildroot-$(BUILDROOT_ARCH)
	cp $(ONL_BUILDROOT)/buildroot-$(BUILDROOT_ARCH)/images/rootfs.cpio.gz onl-buildroot-initrd-$(ARCH).cpio.gz
	cp $(ONL_BUILDROOT)/buildroot-$(BUILDROOT_ARCH)/host/usr/bin/makedevs .
	chmod +x makedevs

$(ONL_BUILDROOT)/.setup.done:
	$(MAKE) -C $(ONL_BUILDROOT) setup
	touch $(ONL_BUILDROOT)/.setup.done


.PHONY: onl-buildroot-initrd-$(ARCH).cpio.gz












