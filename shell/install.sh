#!/bin/zsh
# Description:

# Author: @Mintimate
# Blog: https://www.mintimate.cn/about

# 设置下载地址
FILE_OMZ_ZIP="https://cnb.cool/Mintimate/tool-forge/oh-my-zsh/-/git/raw/main/asset/omz/ohmyzsh-master.zip"
# 国内 oh-my-zsh 镜像仓库
MIRROR_OMZ="https://gitee.com/mirrors/oh-my-zsh.git"
# 下载工具，默认为 curl，没有则使用 wget
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

 # 判断是否为zsh
if ! type zsh >/dev/null 2>&1; then
    echo -e "\033[31m 本脚本为zsh所配置 \033[0m"
    echo -e "\033[31m 请切换Shell为zsh \033[0m"
    exit 1
else
    echo -e "\033[32m zsh? => yes \033[0m"
fi

# 判断是否安装了 curl 或 wget
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

# 判断是否安装了unzip
if ! type unzip >/dev/null 2>&1; then
    echo -e "\033[31m 依赖：unzip 未安装 \033[0m"
    echo -e "\033[31m 请安装unzip \033[0m"
    exit 1
else
    echo -e "\033[32m unzip? => yes \033[0m"
fi
# 用户家目录
USER_HOME=$HOME
if [ ! -d "${USER_HOME}" ]; then
    echo -e "\033[31m 当前用户家目录不存在 \033[0m"
    echo -e "\033[31m 本脚本不支持当前用户 \033[0m"
    exit 1
else
    echo -e "\033[32m 当前用户家目录存在 \033[0m"
    echo -e "\033[32m 前置条件 => 通过 \033[0m"
fi
# 非必要条件判断：Git
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

cd ${USER_HOME}
ohmyzshOld=".oh-my-zsh"
if [ -d "$ohmyzshOld" ]; then
    echo "\033[31m 发现已经安装oh-my-zsh \033[0m"
    echo "\033[31m 备份.oh-my-zsh为oh-my-zsh-Bak \033[0m"
    echo "\033[31m 如需查看之前oh-my-zsh可复盘 \033[0m"
    mv -f ${USER_HOME}/${ohmyzshOld} ${USER_HOME}/oh-my-zsh-Bak >>/dev/null
fi

echo "\033[32m 镜像同步oh-my-zsh源码 \033[0m"
eval ${DOWNLOAD_TOOL} ohmyzsh-master.zip ${FILE_OMZ_ZIP}
echo "\033[32m 使用unzip解压文件 \033[0m"
unzip -o ohmyzsh-master.zip >>/dev/null
echo "\033[32m 移动文件到~/.oh-my-zsh内 \033[0m"

# 判断是否存在.zshrc
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
mv ohmyzsh-master ${USER_HOME}/.oh-my-zsh >>/dev/null
cp ${USER_HOME}/.oh-my-zsh/templates/zshrc.zsh-template ${USER_HOME}/.zshrc >>/dev/null

echo "\033[32m 删除本脚本带来的残留文件 \033[0m"
rm -rf ohmyzsh-master.zip
rm -rf ohmyzsh-master
if [ ${EnableGit} -eq "1" ];then
    echo "\033[32m 设置oh-my-zsh更新源 \033[0m"
    cd ${USER_HOME}/.oh-my-zsh
    git init > /dev/null 2>&1
    git remote add origin ${MIRROR_OMZ} > /dev/null 2>&1
    git fetch origin > /dev/null 2>&1
    git clean -f > /dev/null 2>&1
    git reset --hard origin/master > /dev/null 2>&1\
else
    echo "\033[32m 无git依赖 => 跳过更新 \033[0m"
fi
cd ${USER_HOME}
echo "\033[32m 生效配置文件 \033[0m"
echo "\033[32m ======================== \033[0m"
echo "\033[32m 配置完成，请重启Terminal查看 \033[0m"
echo "\033[32m 愉快使用oh-my-zsh吧( ´▽｀) \033[0m"