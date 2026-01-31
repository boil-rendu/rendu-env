# ==============================================================================
# Dockerfile for C++ Development Environment
# ==============================================================================
# Description:
#   基于 Ubuntu 20.04 构建的 C++ 开发环境容器镜像
#
# 基础镜像: ubuntu:20.04
# 作者: rendu <419610242@qq.com>
#
# 主要特性:
#   - GCC/G++ 编译工具链
#   - CMake 构建系统
#   - GDB 调试器
#   - SSH 远程连接支持
#   - rsync 文件同步（支持 CLion 远程开发）
#   - 时区设置为 Asia/Shanghai
#   - 使用清华镜像源加速
#
# 使用方法:
#   docker build -t boiling/cpp_env:latest .
#   docker run -d -p 23:22 boiling/cpp_env:latest
# ==============================================================================

# 使用 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 添加镜像标签信息
LABEL rendu <419610242@qq.com>

# ==============================================================================
# 镜像源配置
# ==============================================================================

# 备份原始软件源列表
RUN cd /etc/apt \
    cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 替换为清华大学镜像源（加速软件包下载）
# 将 archive.ubuntu.com、security.ubuntu.com、ports.ubuntu.com 替换为清华镜像
RUN sed -i 's@/archive.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g' /etc/apt/sources.list && \
    sed -i 's@/security.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g' /etc/apt/sources.list && \
    sed -i 's@/ports.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g' /etc/apt/sources.list 

# ==============================================================================
# 环境变量设置
# ==============================================================================

# 设置时区为 Asia/Shanghai（东八区）
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

# DEBIAN_FRONTEND=noninteractive: 防止安装软件时弹出交互式提示

# ==============================================================================
# 系统更新和软件包安装
# ==============================================================================

# 清理 apt 缓存
RUN apt clean

# 更新软件包列表
RUN apt update

# 升级已安装的软件包
RUN apt -y upgrade

# ==============================================================================
# 通用工具安装
# ==============================================================================

# Vim - 文本编辑器
RUN apt-get install -y vim

# Git - 版本控制工具
RUN apt-get install -y git

# net-tools - 网络工具（包含 ifconfig、netstat 等）
RUN apt-get install -y net-tools

# iputils-ping - ping 工具
RUN apt-get install -y iputils-ping

# ==============================================================================
# SSH 服务配置
# ==============================================================================

# 安装 OpenSSH 服务器
RUN apt-get install -y openssh-server

# 创建 SSH 运行时目录
RUN mkdir /var/run/sshd

# 修改 SSH 配置允许 root 登录
# 这对 Docker 容器来说是必要的，因为容器内通常只有 root 用户
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# 备用配置（已注释）: 禁用 PAM 认证
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# ==============================================================================
# Rsync 服务配置（支持 CLion 远程开发）
# ==============================================================================

# 安装 rsync 文件同步工具
# rsync 用于在宿主机和容器之间同步代码文件
RUN apt-get install -y rsync

# 修改 rsync 默认配置，启用服务
RUN sed -ri 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g' /etc/default/rsync

# 创建 rsync 同步目录
RUN mkdir /root/sync

# 复制 rsync 配置文件到容器内
COPY rsync.conf /etc

# ==============================================================================
# C++ 编译工具链安装
# ==============================================================================

# build-essential - 包含 GCC、G++、make 等基础编译工具
RUN apt-get install -y build-essential

# CMake - 跨平台构建系统
RUN apt-get install -y cmake

# GDB - GNU 调试器
RUN apt-get install -y gdb

# Ninja-build - 快速构建系统，CMake 的后端之一
RUN apt-get install -y ninja-build

# ==============================================================================
# 缓存清理
# ==============================================================================

# 删除 apt 更新产生的缓存文件
# Docker 的文件系统是分层文件系统，如果保留缓存会导致镜像体积增大
# 清理这些文件可以减小最终镜像的大小
RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ==============================================================================
# 用户配置
# ==============================================================================

# 设置 root 用户密码为 root
# 用于 SSH 登录和容器内操作
RUN echo 'root:root' |chpasswd

# ==============================================================================
# 容器启动配置
# ==============================================================================

# 默认执行命令（会在 docker-entrypoint.sh 中定义）
CMD [ "rd_cpp_env" ]

# 复制容器启动脚本
COPY docker-entrypoint.sh /usr/local/bin/

# 设置启动脚本为可执行
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 设置容器入口点为启动脚本
ENTRYPOINT [ "docker-entrypoint.sh" ]

