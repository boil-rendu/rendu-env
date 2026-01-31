#!/bin/bash

################################################################################
# 按日期卸载 Homebrew 包 - Uninstall Homebrew Packages by Date
#
# 用法: ./uninstall-brew-by-date.sh [YYYY-MM-DD]
# 示例: ./uninstall-brew-by-date.sh 2025-01-30
#       ./uninstall-brew-by-date.sh          (默认卸载今天安装的包)
################################################################################

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检测 brew 路径
get_cellar_path() {
    if [ -d "/opt/homebrew/Cellar" ]; then
        echo "/opt/homebrew/Cellar"
    elif [ -d "/usr/local/Cellar" ]; then
        echo "/usr/local/Cellar"
    else
        echo ""
    fi
}

# 获取包的安装日期
get_install_date() {
    local pkg=$1
    local cellar_path=$(get_cellar_path)
    local pkg_path="$cellar_path/$pkg"

    if [ -d "$pkg_path" ]; then
        stat -f "%Sm" -t "%Y-%m-%d" "$pkg_path" 2>/dev/null || stat -c "%y" "$pkg_path" 2>/dev/null | cut -d' ' -f1
    fi
}

# 查找指定日期安装的包
find_packages_by_date() {
    local target_date=$1
    local found_packages=()

    for pkg in $(brew list --formula); do
        local install_date=$(get_install_date "$pkg")
        if [ "$install_date" = "$target_date" ]; then
            found_packages+=("$pkg")
        fi
    done

    echo "${found_packages[@]}"
}

# 显示指定日期安装的包
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

# 卸载包
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

# 主函数
main() {
    # 默认日期: 今天
    TARGET_DATE="${1:-$(date +%Y-%m-%d)}"

    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   Homebrew 包卸载工具                           ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════╝${NC}"
    echo ""

    # 显示目标日期的包
    show_packages "$TARGET_DATE" || exit 0

    # 确认卸载
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

print_step() {
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 运行主函数
main "$@"
