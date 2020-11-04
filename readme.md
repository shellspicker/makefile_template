# 一个简单易用的makefile模板

## 特点介绍

* 目前仅用于c, cpp的编译(命令是gcc, g++).
* 支持多目标编译.
* 规则不需要手写, 只要写目标名和文件名等关键信息即可.

使用方法见`Makefile`.

## 目录结构

1. `Makefile`: 主makefile, 目标信息在这里写.
2. `mk/env.mk`: 一些环境变量.
3. `mk/recipe.mk`: 编译的核心操作.
4. `mk/target.mk`: 目标的定义.
5. `mk/util.mk`: 工具函数.

一般来说, 修改`Makefile`和`mk/env.mk`即可.

## 实现思路

有机会的话会写的.
