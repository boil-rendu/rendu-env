#!/bin/bash
# 显示所有 brew 包的安装时间（按时间从早到晚排序）

echo "Homebrew Packages Installation Time (Oldest First):"
echo "===================================================="

for pkg in $(brew list --formula); do
  # 获取 Cellar 目录的修改时间
  cellar_path="/opt/homebrew/Cellar/$pkg"
  if [ ! -d "$cellar_path" ]; then
    cellar_path="/usr/local/Cellar/$pkg"
  fi

  if [ -d "$cellar_path" ]; then
    # 获取时间戳用于排序
    timestamp=$(stat -f "%m" "$cellar_path" 2>/dev/null)
    install_time=$(ls -ld "$cellar_path" | awk '{print $6, $7, $8}')
    echo "$timestamp|$pkg|$install_time"
  fi
done | sort -n | awk -F'|' '{printf "%-25s %s\n", $2, $3}'
