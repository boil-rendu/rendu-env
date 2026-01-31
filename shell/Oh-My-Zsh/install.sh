#!/bin/zsh
# ==============================================================================
# Oh My Zsh 一键安装脚本（国内镜像源版本）
# ==============================================================================
# Description:
#   本脚本用于自动安装 Oh My Zsh 并配置为使用国内镜像源，解决国内网络访问问题
#
# Author: @Mintimate
# Blog: https://www.mintimate.cn/about
# Repository: https://github.com/FRBoiling/rendu-env
#
# 功能特性:
#   1. 自动检测并安装 Oh My Zsh
#   2. 配置使用国内 Gitee 镜像源加速更新
#   3. 自动备份现有配置文件
#   4. 支持交互式安装和自动化安装
#
# 依赖工具:
#   - zsh (必需)
#   - curl 或 wget (必需)
#   - unzip (必需)
#   - git (可选，用于自动更新)
#
# 使用方法:
#   chmod +x install.sh
#   ./install.sh
#
# 返回值:
#   0 - 安装成功
#   1 - 安装失败或前置条件不满足
# ==============================================================================

# ==============================================================================
# 配置变量
# ==============================================================================

# Oh My Zsh 压缩包下载地址（国内镜像）
FILE_OMZ_ZIP="https://cnb.cool/Mintimate/tool-forge/oh-my-zsh/-/git/raw/main/asset/omz/ohmyzsh-master.zip"

# Oh My Zsh Git 仓库国内镜像地址（用于更新）
MIRROR_OMZ="https://gitee.com/mirrors/oh-my-zsh.git"

# 默认下载工具（curl），如果没有安装则回退到 wget
DOWNLOAD_TOOL="curl -s -o"

echo -e "\033[32m
_____________________________________________________________
    _   _
    /  /|     ,                 ,
---/| /-|----------__---_/_---------_--_-----__---_/_-----__-
  / |/  |   /    /   )  /     /    / /  )  /   )  /     /___)
_/__/___|__/____/___/__(_ ___/____/_/__/__(___(__(_ ___(___ _
         Mintimate's Blog:https://www.mintimate.cn
            Oh-my-zsh 一键安装并配置国内更新源版本
_____________________________________________________________
 \033[0m"

# ==============================================================================
# 环境检测部分
# ==============================================================================

# 检测当前是否使用 zsh shell
# zsh 是 Oh My Zsh 的前置条件
if ! type zsh >/dev/null 2>&1; then
    echo -e "\033[31m 本脚本为zsh所配置 \033[0m"
    echo -e "\033[31m 请切换Shell为zsh \033[0m"
    exit 1
else
    echo -e "\033[32m zsh? => yes \033[0m"
fi

# 检测是否安装了下载工具（curl 或 wget）
# 两种工具至少需要一种才能下载 Oh My Zsh 安装包
if type wget >/dev/null 2>&1; then
    DOWNLOAD_TOOL="wget -qO"
    echo -e "\033[32m wget? => yes \033[0m"
elif type curl >/dev/null 2>&1; then
    DOWNLOAD_TOOL="curl -s -o"
    echo -e "\033[32m curl? => yes \033[0m"
else
    echo -e "\033[31m 依赖：curl 或 wget 未安装 \033[0m"
    echo -e "\033[31m 请安装curl 或 wget \033[0m"
    exit 1
fi

# 检测是否安装了解压工具 unzip
# unzip 用于解压下载的 Oh My Zsh 压缩包
if ! type unzip >/dev/null 2>&1; then
    echo -e "\033[31m 依赖：unzip 未安装 \033[0m"
    echo -e "\033[31m 请安装unzip \033[0m"
    exit 1
else
    echo -e "\033[32m unzip? => yes \033[0m"
fi
# ==============================================================================
# 用户环境检测
# ==============================================================================

# 获取当前用户家目录路径
# 所有 Oh My Zsh 文件都将安装到此目录下
USER_HOME=$HOME
if [ ! -d "${USER_HOME}" ]; then
    echo -e "\033[31m 当前用户家目录不存在 \033[0m"
    echo -e "\033[31m 本脚本不支持当前用户 \033[0m"
    exit 1
else
    echo -e "\033[32m 当前用户家目录存在 \033[0m"
    echo -e "\033[32m 前置条件 => 通过 \033[0m"
fi

# ==============================================================================
# Git 检测（非必需，但建议安装）
# ==============================================================================

# 检测是否安装了 Git
# Git 用于 Oh My Zsh 的自动更新功能，不是安装必需条件
EnableGit=0
if ! type git >/dev/null 2>&1; then
    echo -e "\033[31m 非必要条件:git => 未安装 \033[0m"
    echo -e "\033[31m 缺少Git => oh-my-zsh不会自动更新 \033[0m"
    echo -e "\033[31m 请问： \033[0m"
    echo -e "\033[31m ================ \033[0m"
    echo -e "\033[31m 是否继续运行本脚本？ \033[0m"
    echo -e "\033[31m 继续安装 => y \033[0m"
    read temp
    if [ ${temp} = "y" ];then
        echo -e "\033[32m 继续安装oh-my-zsh \033[0m"
    else
        echo -e "\033[32m 脚本已经终止 \033[0m"
        exit 1
    fi
else
    echo -e "\033[32m 非必要条件:git => 已安装 \033[0m"
    echo -e "\033[32m oh-my-zsh更新条件 => 满足 \033[0m"
    EnableGit=1
fi

# 确认信息
echo -e "\033[32m_____________________________________________________________\033[0m"
echo -e "\033[33m 是否确认安装本脚本？\033[0m"
echo -e "\033[33m 输入y后回车=>继续安装；其他键后回车=>取消安装 \033[0m"
read temp
if [ ${temp} = "y" ];then
    echo -e "\033[32m 继续安装oh-my-zsh \033[0m"
else
    echo -e "\033[32m 脚本已经终止 \033[0m"
    exit 1
fi

# ==============================================================================
# 安装执行部分
# ==============================================================================

# 切换到用户家目录
cd ${USER_HOME}

# 检测并备份已存在的 Oh My Zsh 安装
# 如果已经安装了 Oh My Zsh，将其备份为 oh-my-zsh-Bak
ohmyzshOld=".oh-my-zsh"
if [ -d "$ohmyzshOld" ]; then
    echo "\033[31m 发现已经安装oh-my-zsh \033[0m"
    echo "\033[31m 备份.oh-my-zsh为oh-my-zsh-Bak \033[0m"
    echo "\033[31m 如需查看之前oh-my-zsh可复盘 \033[0m"
    mv -f ${USER_HOME}/${ohmyzshOld} ${USER_HOME}/oh-my-zsh-Bak >>/dev/null
fi

# 下载 Oh My Zsh 压缩包（使用国内镜像源）
echo "\033[32m 镜像同步oh-my-zsh源码 \033[0m"
eval ${DOWNLOAD_TOOL} ohmyzsh-master.zip ${FILE_OMZ_ZIP}

# 解压下载的压缩包
echo "\033[32m 使用unzip解压文件 \033[0m"
unzip -o ohmyzsh-master.zip >>/dev/null

# 移动解压后的文件到 ~/.oh-my-zsh 目录
echo "\033[32m 移动文件到~/.oh-my-zsh内 \033[0m"

# 检测并备份已存在的 .zshrc 配置文件
# 如果存在 .zshrc，将其备份为 zshrcBak
cd ${USER_HOME}
zshrc=".zshrc"
if [ ! -f "$zshrc" ]; then
    echo "\033[32m .zshrc不存在 \033[0m"
    echo "\033[32m 备份环节跳过! \033[0m"
else
    echo "\033[31m .zshrc配置文件已存在 \033[0m"
    echo "\033[31m 重命名.zshrc为zshrcBak \033[0m"
    echo "\033[31m 如需查看之前环境变量可复盘 \033[0m"
    mv -f ${USER_HOME}/${zshrc} ${USER_HOME}/zshrcBak >>/dev/null
fi

# 移动 Oh My Zsh 到安装目录
mv ohmyzsh-master ${USER_HOME}/.oh-my-zsh >>/dev/null

# 复制默认配置文件模板到 .zshrc
cp ${USER_HOME}/.oh-my-zsh/templates/zshrc.zsh-template ${USER_HOME}/.zshrc >>/dev/null

# ==============================================================================
# 清理临时文件和配置更新源
# ==============================================================================

# 删除下载的压缩包和解压后的临时目录
echo "\033[32m 删除本脚本带来的残留文件 \033[0m"
rm -rf ohmyzsh-master.zip
rm -rf ohmyzsh-master

# 如果安装了 Git，配置 Oh My Zsh 使用国内镜像源
# 这样可以解决 Oh My Zsh 更新时的网络问题
if [ ${EnableGit} -eq "1" ];then
    echo "\033[32m 设置oh-my-zsh更新源 \033[0m"
    cd ${USER_HOME}/.oh-my-zsh

    # 初始化 Git 仓库
    git init > /dev/null 2>&1

    # 添加国内镜像远程仓库
    git remote add origin ${MIRROR_OMZ} > /dev/null 2>&1

    # 获取远程仓库内容
    git fetch origin > /dev/null 2>&1

    # 清理未跟踪的文件
    git clean -f > /dev/null 2>&1

    # 重置到远程仓库的主分支
    git reset --hard origin/master > /dev/null 2>&1
else
    echo "\033[32m 无git依赖 => 跳过更新 \033[0m"
fi

# ==============================================================================
# 安装完成
# ==============================================================================

# 切换回用户家目录
cd ${USER_HOME}

# 提示用户重新加载配置
echo "\033[32m 生效配置文件 \033[0m"
echo "\033[32m ======================== \033[0m"
echo "\033[32m 配置完成，请重启Terminal查看 \033[0m"
echo "\033[32m 愉快使用oh-my-zsh吧( ´▽｀) \033[0m"