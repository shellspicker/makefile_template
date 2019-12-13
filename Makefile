# If we running by kernel building system
ifneq ($(KERNELRELEASE),)
# -m: 以模块方式.
# -objs: 常见的依赖添加方式.
# -y: 也是依赖添加, 似乎还能编进内核?
    obj-m := xxx.o
    xxx-objs +=
    xxx-y +=
# If we are running without kernel build system
else
    BUILDSYSTEM_DIR?=/lib/modules/$(shell uname -r)/build
    PWD:=$(shell pwd)
all :
# run kernel build system to make module
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) modules
clean:
# run kernel build system to cleanup in current directory
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) clean
endif
