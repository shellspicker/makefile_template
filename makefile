a := qqq
b := www
c := eee
d := rrr

names := a b c d
suf := .cpp
filename := xxx.cpp

define fun
	$(eval str := 666)
	@echo "before undefine: $(str)"
endef

#	echo jojo
# above will cause error "recipe before rules. stop."

# in define, set var, value of var must sure(defined).
# this func must call with eval, otherwise is unuseful.
# random value define with ?= can be sure only one possible, even multi def,
# but if define with other symbol like =, eval once will perm one random value.
define func_defvar
rnd_inside ?= $(shell mktemp -u XXX)
endef

# call this func with eval, cause double eval.
# use define to def var, eval any time is same, see test_rnd_inside.
#	$(eval $(call func_defvar))
#	$(call func_eval_defvar)
#	$(eval $(call func_eval_defvar))
# above 3 call is same.
define func_eval_defvar
	$(eval $(call func_defvar))
endef

# outside var is different with inside define var, only use := can be sure
# there is only one call the var get value func(random).
rnd_outside = $(shell mktemp -u XXX)
rnd2_outside = $(rnd_outside)
rnd3_$(rnd_outside) := 233
rnd4_$(rnd2_outside) := 666

# must eval.
# set varname = value.
define func_set_var
$(1) := $(2)
endef

define func_call_set_var_and_prt
	$(eval $(call func_set_var, $(1), $(2)))
	@echo "$(1) set value is $(2)"
endef

define func_ifdef_var
	ifndef $(1)
		$(2) := ddd
	else
		$(2) := mmm
	endif
endef

define eval_origin_symbol
	var = 233
	cpvar = $$(var)
endef

# $(1) is a suffixname, we want to dim a var with $(suffixname).
# sample: a outside var id = 1, we pass id in this func,
# now $(1) is id, and we want $(id) = 1, append it into suffix.
define double_getarg_to_define_var
	pre_$($(1)) := 666
endef

vara = aaa
varb := $(vara)
varc = ccc
define define_var_and_undefine
	undefine vara
endef

default: all

test_def_var:
	$(eval $(call func_set_var, dsm, yyy))
	$(eval $(call func_ifdef_var, dsm, zgh))
	@echo "zgh is $(zgh)"

test_func_set_var:
	$(call func_call_set_var_and_prt, zgh, 666)
	@echo "zgh is $(zgh)"

test_rnd_outside:
	@echo "rnd = $(rnd_outside)"
	@echo "rnd = $(rnd_outside)"
	@echo "rnd2 = $(rnd2_outside)"
	@echo "rnd2 = $(rnd2_outside)"
	@echo "rnd3 = $(rnd3_$(rnd_outside))"
	@echo "rnd4 = $(rnd4_$(rnd2_outside))"

test_rnd_inside:
#	$(eval $(call func_defvar))
#	$(call func_eval_defvar)
	$(eval $(call func_eval_defvar))
	@echo "rnd = $(rnd_inside)"
	@echo "rnd = $(rnd_inside)"

test_double_def: test_rnd_inside
	$(eval $(call func_eval_defvar))
	@echo "rnd = $(rnd_inside)"
	@echo "rnd = $(rnd_inside)"
	@echo "rnd = $(rnd_inside)"
	@echo "rnd = $(rnd_inside)"

test_foreach_eval:
	@echo $(a) $(b) $(c) $(d)
	$(foreach n,$(names),$(eval $(n) := 233))
	@echo $(a) $(b) $(c) $(d)

test_subst_with_var:
	@echo $(filename:$(suf)=.o)

test_call_func:
	$(call fun)
	@echo "out func, str = $(str)"
	$(eval undefine str)
	@echo "after undefine: $(str)"

test_make_sub_notpass_var:
	make test_double_eval
	@echo "rnd = $(rnd_inside)"

test_eval_with_getvalue_symbol_origin_char:
	$(eval $(call eval_origin_symbol))
	@echo $(var) $(cpvar)

test_double_point_define_var:
	$(eval id = 1)
	$(eval $(call double_getarg_to_define_var,id))
	@echo "$(pre_1)"

test_define_var_and_undefine:
	$(eval $(call define_var_and_undefine))
	@echo "vara: $(vara)"
	@echo "varb: $(varb)"
	@echo "varc: $(varc)"

all: test_rnd_outside
	@echo $$
