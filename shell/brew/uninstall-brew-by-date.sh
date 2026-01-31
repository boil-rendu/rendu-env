#!/bin/bash
# ==============================================================================
# 按日期卸载 Homebrew 包
# ==============================================================================
# Description:
#   根据安装日期批量卸载 Homebrew 包
#   可以指定日期或默认卸载当天安装的包
#
# Author: rendu-env
#
# 用法: ./uninstall-brew-by-date.sh [YYYY-MM-DD]
#
# 示例:
#   ./uninstall-brew-by-date.sh 2025-01-30   # 卸载指定日期的包
#   ./uninstall-brew-by-date.sh             # 默认卸载今天安装的包
#
# 功能特性:
#   1. 自动检测 Homebrew 安装路径
#   2. 按日期查找已安装的包
#   3. 交互式确认卸载
#   4. 彩色输出，易于阅读
#   5. 显示卸载进度和结果统计
#
# 依赖:
#   - Homebrew
#   - bash
# ==============================================================================

# ==============================================================================
# 颜色定义
# ==============================================================================

GREEN='\033[0;32m'      # 成功信息
YELLOW='\033[1;33m'    # 警告信息
RED='\033[0;31m'       # 错误信息
BLUE='\033[0;34m'      # 提示信息
NC='\033[0m'           # 无颜色（重置）

# ==============================================================================
# 工具函数：打印带颜色的消息
# ==============================================================================

# 打印提示信息（蓝色）
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 打印成功信息（绿色）
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 打印警告信息（黄色）
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 打印错误信息（红色）
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ==============================================================================
# 路径检测函数
# ==============================================================================

# 获取 Homebrew Cellar 路径
# 支持 Intel Mac 和 Apple Silicon Mac
get_cellar_path() {
    if [ -d "/opt/homebrew/Cellar" ]; then
        # Apple Silicon Mac (M1/M2/M3)
        echo "/opt/homebrew/Cellar"
    elif [ -d "/usr/local/Cellar" ]; then
        # Intel Mac
        echo "/usr/local/Cellar"
    else
        # 未找到 Homebrew 安装路径
        echo ""
    fi
}

# ==============================================================================
# 日期查询函数
# ==============================================================================

# 获取指定包的安装日期
# 参数: $1 - 包名
# 返回: 安装日期 (YYYY-MM-DD 格式)
get_install_date() {
    local pkg=$1
    local cellar_path=$(get_cellar_path)
    local pkg_path="$cellar_path/$pkg"

    if [ -d "$pkg_path" ]; then
        # macOS 使用 stat -f 格式，Linux 使用 stat -c 格式
        stat -f "%Sm" -t "%Y-%m-%d" "$pkg_path" 2>/dev/null || \
        stat -c "%y" "$pkg_path" 2>/dev/null | cut -d' ' -f1
    fi
}

# ==============================================================================
# 包查询函数
# ==============================================================================

# 查找指定日期安装的所有包
# 参数: $1 - 目标日期 (YYYY-MM-DD)
# 返回: 包列表（数组）
find_packages_by_date() {
    local target_date=$1
    local found_packages=()

    # 遍历所有已安装的包
    for pkg in $(brew list --formula); do
        local install_date=$(get_install_date "$pkg")
        if [ "$install_date" = "$target_date" ]; then
            found_packages+=("$pkg")
        fi
    done

    echo "${found_packages[@]}"
}

# ==============================================================================
# 显示函数
# ==============================================================================

# 显示指定日期安装的包
# 参数: $1 - 目标日期
show_packages() {
    local target_date=$1
    local packages=($(find_packages_by_date "$target_date"))

    if [ ${#packages[@]} -eq 0 ]; then
        print_warning "未找到 $target_date 安装的包"
        return 1
    fi

    echo ""
    echo -e "${YELLOW}在 $target_date 安装的包:${NC}"
    echo "===================================="
    for pkg in "${packages[@]}"; do
        echo "  • $pkg"
    done
    echo ""
}

# ==============================================================================
# 卸载函数
# ==============================================================================

# 卸载指定的包列表
# 参数: $@ - 包列表
uninstall_packages() {
    local packages=("$@")
    local success_count=0
    local fail_count=0

    for pkg in "${packages[@]}"; do
        print_info "正在卸载 $pkg..."
        if brew uninstall "$pkg" 2>/dev/null; then
            print_success "$pkg 已卸载"
            success_count=$((success_count + 1))
        else
            print_error "$pkg 卸载失败"
            fail_count=$((fail_count + 1))
        fi
    done

    echo ""
    print_info "卸载完成: 成功 $success_count 个, 失败 $fail_count 个"
}

# ==============================================================================
# 主函数
# ==============================================================================

main() {
    # 默认日期: 今天
    TARGET_DATE="${1:-$(date +%Y-%m-%d)}"

    # 打印标题
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   Homebrew 包卸载工具                           ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════╝${NC}"
    echo ""

    # 显示目标日期的包
    show_packages "$TARGET_DATE" || exit 0

    # 交互式确认卸载
    read -p "确定要卸载以上所有包吗？(y/n): " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "卸载已取消"
        exit 0
    fi

    # 获取要卸载的包列表
    local packages=($(find_packages_by_date "$TARGET_DATE"))

    if [ ${#packages[@]} -eq 0 ]; then
        print_warning "没有包需要卸载"
        exit 0
    fi

    # 执行卸载
    echo ""
    print_step "开始卸载..."
    echo ""
    uninstall_packages "${packages[@]}"

    echo ""
    print_success "所有操作完成！"
}

# 辅助函数：打印步骤分隔线
print_step() {
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# ==============================================================================
# 脚本入口
# ==============================================================================

# 运行主函数，传递所有命令行参数
main "$@"
