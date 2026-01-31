#!/bin/bash
# ==============================================================================
# Homebrew 包安装时间查询脚本
# ==============================================================================
# Description:
#   显示所有已安装的 Homebrew 包及其安装时间
#   按时间从早到晚排序，方便查看包的安装历史
#
# Author: rendu-env
#
# 功能特性:
#   1. 自动检测 Homebrew 安装路径（支持 Intel 和 Apple Silicon）
#   2. 显示每个包的安装日期和时间
#   3. 按时间排序输出
#
# 使用方法:
#   chmod +x list-brew-packages-by-date.sh
#   ./list-brew-packages-by-date.sh
#
# 输出格式:
#   包名                  安装时间
#   example-package        Jan 30 10:25
# ==============================================================================

echo "Homebrew Packages Installation Time (Oldest First):"
echo "===================================================="

# ==============================================================================
# 主逻辑：遍历所有已安装的包并获取安装时间
# ==============================================================================

for pkg in $(brew list --formula); do
  # 获取 Cellar 目录的修改时间
  # 首先尝试 Apple Silicon 路径，然后尝试 Intel 路径
  cellar_path="/opt/homebrew/Cellar/$pkg"
  if [ ! -d "$cellar_path" ]; then
    cellar_path="/usr/local/Cellar/$pkg"
  fi

  # 如果包目录存在，获取其时间信息
  if [ -d "$cellar_path" ]; then
    # 获取时间戳用于排序（Unix 时间戳）
    timestamp=$(stat -f "%m" "$cellar_path" 2>/dev/null)

    # 获取可读的安装时间
    install_time=$(ls -ld "$cellar_path" | awk '{print $6, $7, $8}')

    # 输出格式: 时间戳|包名|可读时间
    echo "$timestamp|$pkg|$install_time"
  fi
# 按时间戳排序并格式化输出
done | sort -n | awk -F'|' '{printf "%-25s %s\n", $2, $3}'
