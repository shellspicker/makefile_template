include mk/env.mk
include mk/recipe.mk

# 这块自行修改.
.PHONY: init_all
init_all:
# 添加需要的目标文件.
# 自定义文件, 支持多个目标, 写好每个目标的信息.
# 定义每个目标调用一次dim_file_relevant.
# example:
#	$(eval $(call dim_file_relevant,id,mode,target,src))
	@$(foreach id,$(aimid_all),\
		$(eval $(call preprocess,$(id)))\
		$(eval REQ_$(id) = $(OBJS_$(id)))\
		)
# 根据上面的id, 添加不同模块间的依赖(如果有的话).
# example(后缀XXX,YYY换成id):
#	$(eval REQ_XXX += $(ALL_YYY))
	@$(foreach id,$(aimid_all),\
		$(eval export REQ_$(id))\
		)
	$(eval export aimid_all TARGET)

include mk/target.mk
include mk/util.mk
