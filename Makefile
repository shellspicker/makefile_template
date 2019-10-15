# 编译参数
CC := gcc
CXX := g++
AR := ar
RANLIB := ranlib
SHARE := -fpic -shared -o
INCLUDE := -I./ \
	-I/usr/include/ \
	-I/usr/local/include/
LIBS := -L./ \
	-L/usr/lib/ \
	-L/usr/lib32/ \
	-L/usr/local/lib/
LDFLAGS :=
DEFINES :=
CFLAGS := -g -Wall -O2 $(INCLUDE) $(DEFINES)
CXXFLAGS := -std=c++11 $(CFLAGS) -DHAVE_CONFIG_H

# make工具, Makefile指定.
MAKE = make
MAKEFILE = Makefile

# 文件扩展名相关.
SRCEXT = .c .cc .cpp .cxx .c++

# default target
default: all

# 这块自行修改.
# 所有目标, 填对应的后缀数字即可.
.PHONY: aimid_all init_all
aimid_all = 1
init_all:
	@$(foreach id,$(aimid_all),$(eval $(call preprocess,$(id))))
# 自定义文件, 支持多个目标, 写好每个目标的源文件名和目标文件名.
# 有编译可执行文件, 静态链接库, 动态链接库.
EXE_1 :=
STATIC_1 :=
DYNAMIC_1 :=
ALL_1 := $(EXE_1) $(STATIC_1) $(DYNAMIC_1)
SRCS_1 :=
ifdef OBJS_1
	sinclude $(OBJS_1:.o=.d)
endif
# 具体编译过程, 这里可能会把其他目标的OBJS一起编译进来.
# LDFLAGS仅在链接时使用.
$(EXE_1): $(OBJS_1)
	$(CC_1) -o $@ $^ $(LIBS) $(LDFLAGS)
$(STATIC_1): $(OBJS_1)
	$(AR) crs $@ $^
	$(RANLIB) $@
$(DYNAMIC_1): $(OBJS_1)
	$(CC_1) $(SHARE) $@ $^ $(LDFLAGS) $(LIBS)
# 所有目标合集, 多目标的话把所有需要的都放到这里.
TARGET :=

# 以下一般不需要改
.PHONY: build rebuild all clean cleanall
build: all
rebuild: cleanall build
all: init_all
	$(MAKE) -f $(MAKEFILE) $(TARGET)
clean: init_all
	rm -f *.orig *~ *.o *.d
cleanall: clean
	rm -f $(TARGET)

# 约定俗成的根据源文件自动生成头文件依赖.
# func: get dependence rule file.
# arg: src, dep_file, compiler.
# src file like .c .cpp ...
# dependence rule file like .d .o: .c(pp) .h(pp) ...
define mkdep
	@set -e
	@rm -f $(2)
	@$(3) -MM $(1) | awk '{print "$(2)", $$0}' > $(2)
endef
%.d: %.c
	@$(call mkdep,$<,$@,$(CC))

%.d: %.cpp
	@$(call mkdep,$<,$@,$(CXX))

# 以下是生成.d文件的4种方法.
# 形如%.d %.o: %.c something.h...
# 生成.d的原因是.h里面增加或减少包含其他.h文件, .d也能同步更新.
#@$(CC) -MM $< | awk '{print "$@", $$0}' > $@
#@$(CC) -MM $< | awk '{printf "%s %s\n", "$@", $$0}' > $@
#@$(CC) -MM $< | sed 's:^\(.*\):$@ \1:g' > $@
#@$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
#	sed 's,\($*\)\.o[ :]*,\1.o $@: ,g' < $@.$$$$ > $@; \
#	rm -f $@.$$$$

# func: get suffix, match them in SRCEXT.
# arg: srcs.
get_suffix = $(filter $(suffix $(1)),$(SRCEXT))
# func: get suffix is .c or .cpp...
# arg: srcs, suffix.
define init_suffix
	ifeq ($(words $(call get_suffix,$(1))),1)
		$(2) := $(call get_suffix,$(1))
	endif
endef
# func: get compiler is gcc or g++.
# arg: suffix, compiler.
define init_compiler
	ifeq ($(1),.c)
		$(2) := $(CC)
	endif
	ifeq ($(1),.cpp)
		$(2) := $(CXX)
	endif
endef

# 按照源文件类型获得后缀和编译器类型.
define preprocess
	$(eval $(call init_suffix,$(SRCS_$(1)),SUFFIX_$(1)))
	$(eval $(call init_compiler,$(SUFFIX_$(1)),CC_$(1)))
	OBJS_$(1) = $(SRCS_$(1):$(SUFFIX_$(1))=.o)
	TARGET += $(ALL_$(1))
	export SUFFIX_$(1) CC_$(1) OBJS_$(1)
endef

# debug, call as below.
#	@$(foreach id,$(aimid_all),$(call debug_preprocess,$(id)))
define debug_preprocess
	@echo debug begin!!!
	@echo suffix: $(SUFFIX_$(1))$$
	@echo cc: $(CC_$(1))$$
	@echo objs: $(OBJS_$(1))$$
	@echo debug end!!!
endef
