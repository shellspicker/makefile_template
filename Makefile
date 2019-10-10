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
# make工具, Makefile指定
#MAKE = make
#MAKEFILE = Makefile

# default target
default: all

# 这块自行修改.
# 自定义文件, 支持多个目标, 写好每个目标的源文件名和目标文件名.
# 有编译可执行文件, 静态链接库, 动态链接库.
EXE := 
STATIC := 
DYNAMIC := 
SRCS := 
OBJS := $(patsubst %.cpp, %.o, $(SRCS))
sinclude $(OBJS:.o=.d)
# 具体编译过程, 这里可能会把其他目标的OBJS一起编译进来.
# LDFLAGS仅在链接时使用.
$(EXE): $(OBJS)
	$(CXX) -o$@ $^ $(LIBS) $(LDFLAGS)
$(STATIC): $(OBJS)
	$(AR) crs $@ $^
	$(RANLIB) $@
$(DYNAMIC): $(OBJS)
	$(CXX) $(SHARE) $@ $^ $(LDFLAGS) $(LIBS)
# 所有目标合集, 多目标的话把所有需要的都放到这里.
TARGET := $(EXE) $(STATIC) $(DYNAMIC)

# 以下一般不需要改
.PHONY: all
all:
	$(MAKE) $(TARGET)
.PHONY: clean
clean:
	rm -f *.orig *~ *.o *.d
cleanall: clean
	rm -f $(TARGET)

# 约定俗成的根据源文件自动生成头文件依赖.
%.d: %.c
	@set -e
	@rm -f $@
	@$(CC) -MM $< | awk '{print "$@", $$0}' > $@

%.d: %.cpp
	@set -e
	@rm -f $@
	@$(CXX) -MM $< | awk '{print "$@", $$0}' > $@

# 以下是生成.d文件的4种方法.
# 形如%.d %.o: %.c something.h...
# 生成.d的原因是.h里面增加或减少包含其他.h文件, .d也能同步更新.
#@$(CC) -MM $< | awk '{print "$@", $$0}' > $@
#@$(CC) -MM $< | awk '{printf "%s %s\n", "$@", $$0}' > $@
#@$(CC) -MM $< | sed 's:^\(.*\):$@ \1:g' > $@
#@$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
#	sed 's,\($*\)\.o[ :]*,\1.o $@: ,g' < $@.$$$$ > $@; \
#	rm -f $@.$$$$
