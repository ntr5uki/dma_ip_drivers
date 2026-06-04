SHELL = /bin/bash
#
# optional makefile parameters:
# - DEBUG=<0|1>,	enable verbose debug print-out in the driver
# - config_bar_num=,	xdma pci config bar number
# - xvc_bar_num=,	xvc pci bar #
# - xvc_bar_offset=,	xvc register base offset
# 
ifneq ($(xvc_bar_num),)
	XVC_FLAGS += -D__XVC_BAR_NUM__=$(xvc_bar_num)
endif

ifneq ($(xvc_bar_offset),)
	XVC_FLAGS += -D__XVC_BAR_OFFSET__=$(xvc_bar_offset)
endif

$(warning XVC_FLAGS: $(XVC_FLAGS).)

TARGET_MODULE:=xdma

ccflags-y := -I$(src)/../include $(XVC_FLAGS)
ifeq ($(DEBUG),1)
	ccflags-y += -D__LIBXDMA_DEBUG__
endif
ifneq ($(config_bar_num),)
	ccflags-y += -DXDMA_CONFIG_BAR_NUM=$(config_bar_num)
endif
#ccflags-y += -DINTERNAL_TESTING

ifneq ($(KERNELRELEASE),)
	$(TARGET_MODULE)-objs := libxdma.o xdma_cdev.o cdev_ctrl.o cdev_events.o cdev_sgdma.o cdev_xvc.o cdev_bypass.o xdma_mod.o xdma_thread.o
	obj-m := $(TARGET_MODULE).o
else
	KERNEL_VERSION ?= $(shell uname -r)
	KERNEL_BUILD ?= /lib/modules/$(KERNEL_VERSION)/build
	PWD:=$(shell pwd)
all :
	$(MAKE) -C $(KERNEL_BUILD) M=$(PWD) modules

clean:
	$(MAKE) -C $(KERNEL_BUILD) M=$(PWD) clean
	@/bin/rm -f *.ko modules.order *.mod.c *.o *.o.ur-safe .*.o.cmd

install: all
	@echo "installing kernel modules to /lib/modules/$(KERNEL_VERSION)/xdma ..."
	@mkdir -p -m 755 /lib/modules/$(KERNEL_VERSION)/xdma
	@install -v -m 644 *.ko /lib/modules/$(KERNEL_VERSION)/xdma
	@depmod -a $(KERNEL_VERSION) || true

uninstall:
	@echo "Un-installing /lib/modules/$(KERNEL_VERSION)/xdma ..."
	@/bin/rm -rf /lib/modules/$(KERNEL_VERSION)/xdma
	@depmod -a $(KERNEL_VERSION)




endif
