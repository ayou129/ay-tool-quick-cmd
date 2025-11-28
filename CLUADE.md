当前小工具主要功能是 提供cmd 快捷命令提示，以及其他(待完善，这里其实我有想过融入微信输入法，但是一直没找到合适的切入口)

支持的平台有:
- macos

暂时梳理的技术栈:
- Swift + SwiftUI

我目前最迫切想要解决的是：
1. 能够像便签一样 展示在 macos 桌面上，如果可以通过某些方式通过文字搜索出来相关命令 会更方便
2. 如果有一个切入口 例如某个输入法 或者 如果能够开发一个类似 iterm2 的插件 也都可以，因为我在 macos 上几乎都是使用的这个终端工具

目前我整理的命令如下：

访达命令 
●展示所有文件夹 Shift+Command+.
Iterm2命令
●快速打开终端 Command+O

Nano 快捷键
Ctrl+O 保存+Enter
Ctrl+X 退出	Ctrl+K 剪切当前行
Ctrl+U 粘贴
Ctrl+A 行首
Ctrl+E 行末尾
Ctrl+/ 跳到指定行	Ctrl+Y 向上翻页
Ctrl+V 向下翻页
Ctrl+W 搜索文本	Ctrl+Option+6 开启 Mark 标记起点
Ctrl+V+Ctrl+K 删除
linux 命令
wget -L 接受跳转 -O指定路径和文件名tree -d 只显示文件夹      -L 2 只显示2层
     -h 显示文件大小
nvidia-smi
lsb_release -a
cat /etc/nv_tegra_release
nproc 查看核心数
uname -m [aarch64=arm64]sudo shutdown 关机

L4T_VERSION=38.4.0  JETPACK_VERSION=7.1  CUDA_VERSION=13.0
# lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 24.04.3 LTS
Release:	24.04
Codename:	noble

# cat /etc/nv_tegra_release
# R38 (release), REVISION: 2.0, GCID: 41844464, BOARD: generic, EABI: aarch64, DATE: Fri Aug 22 00:55:42 UTC 2025
# KERNEL_VARIANT: oot
TARGET_USERSPACE_LIB_DIR=nvidia
TARGET_USERSPACE_LIB_DIR_PATH=usr/lib/aarch64-linux-gnu/nvidia
INSTALL_TYPE=
