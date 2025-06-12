#!/bin/bash

# VFox 环境部署脚本
# 作者：Claude
# 创建日期：$(date +"%Y-%m-%d")

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 设置日志函数
log_info() {
    echo -e "${GREEN}[信息]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

log_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 检查 jq 是否安装
check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        log_error "未找到 jq 命令。jq 是解析 JSON 配置文件所必需的。"
        log_info "请安装 jq：https://stedolan.github.io/jq/download/"
        exit 1
    fi
}

# 检查配置文件
check_config_file() {
    local config_file="$1"
    
    if [ ! -f "$config_file" ]; then
        log_error "配置文件不存在: $config_file"
        exit 1
    fi
    
    # 检查是否是有效的 JSON 文件
    if ! jq empty "$config_file" 2>/dev/null; then
        log_error "配置文件不是有效的 JSON 格式: $config_file"
        exit 1
    fi
}

# 安装 VFox
install_vfox() {
    log_info "正在安装 VFox..."
    
    # 检查操作系统
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew tap version-fox/tap
            brew install vfox
        else
            curl -sSL https://raw.githubusercontent.com/version-fox/vfox/main/install.sh | bash
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -sSL https://raw.githubusercontent.com/version-fox/vfox/main/install.sh | bash
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* || "$OSTYPE" == "win"* ]]; then
        # Windows
        log_warn "Windows 系统请手动下载安装 VFox: https://github.com/version-fox/vfox/releases"
        log_info "安装完成后，请重新运行此脚本。"
        exit 1
    else
        log_error "不支持的操作系统: $OSTYPE"
        exit 1
    fi
    
    # 检查安装结果
    if ! command -v vfox &> /dev/null; then
        log_error "VFox 安装失败，请手动安装。"
        exit 1
    fi
    
    log_info "VFox 安装成功！"
}

# 配置 VFox SDK 路径
configure_sdk_path() {
    local config_file="$1"
    local sdk_path=$(jq -r '.sdk_path' "$config_file" 2>/dev/null)
    
    if [ -z "$sdk_path" ] || [ "$sdk_path" == "null" ]; then
        log_warn "配置文件中没有 SDK 路径信息，将使用默认路径。"
        return
    fi
    
    log_info "配置 SDK 安装路径: $sdk_path"
    
    # 检查配置文件是否存在
    local vfox_config="$HOME/.version-fox/config.yaml"
    if [ ! -f "$vfox_config" ]; then
        # 如果配置文件不存在，创建它
        mkdir -p "$HOME/.version-fox"
        echo "storage:" > "$vfox_config"
        echo "    sdkPath: $sdk_path" >> "$vfox_config"
        log_info "已创建 VFox 配置文件并设置 SDK 路径"
    else
        # 如果配置文件已存在，检查是否已有 sdkPath 配置
        if grep -q "sdkPath:" "$vfox_config"; then
            # 已有配置，更新它
            sed -i.bak "s|sdkPath:.*|sdkPath: $sdk_path|" "$vfox_config" || \
            sed -i "s|sdkPath:.*|sdkPath: $sdk_path|" "$vfox_config"
            log_info "已更新 VFox 配置文件中的 SDK 路径"
        else
            # 没有配置，添加它
            if grep -q "storage:" "$vfox_config"; then
                # 已有 storage 部分，在其下添加 sdkPath
                sed -i.bak "/storage:/a\\    sdkPath: $sdk_path" "$vfox_config" || \
                sed -i "/storage:/a\\    sdkPath: $sdk_path" "$vfox_config"
            else
                # 没有 storage 部分，添加它
                echo "storage:" >> "$vfox_config"
                echo "    sdkPath: $sdk_path" >> "$vfox_config"
            fi
            log_info "已添加 SDK 路径到 VFox 配置文件"
        fi
    fi
    
    # 确保目录存在
    mkdir -p "$sdk_path"
    log_info "SDK 路径配置完成: $sdk_path"
}

# 配置 Shell
configure_shell() {
    log_info "配置 Shell 环境..."
    
    # 检测当前 Shell
    local current_shell="$(basename "$SHELL")"
    
    case "$current_shell" in
        bash)
            if ! grep -q "vfox activate bash" ~/.bashrc; then
                echo 'eval "$(vfox activate bash)"' >> ~/.bashrc
                log_info "已添加 VFox 到 ~/.bashrc"
            fi
            source ~/.bashrc
            ;;
        zsh)
            if ! grep -q "vfox activate zsh" ~/.zshrc; then
                echo 'eval "$(vfox activate zsh)"' >> ~/.zshrc
                log_info "已添加 VFox 到 ~/.zshrc"
            fi
            source ~/.zshrc
            ;;
        fish)
            if ! grep -q "vfox activate fish" ~/.config/fish/config.fish 2>/dev/null; then
                mkdir -p ~/.config/fish
                echo 'vfox activate fish | source' >> ~/.config/fish/config.fish
                log_info "已添加 VFox 到 ~/.config/fish/config.fish"
            fi
            source ~/.config/fish/config.fish 2>/dev/null || true
            ;;
        *)
            log_warn "未知的 Shell: $current_shell，请手动配置 VFox 环境。"
            log_info "参考命令: vfox activate $current_shell"
            ;;
    esac
    
    log_info "Shell 配置完成！"
}

# 安装插件
install_plugins() {
    local config_file="$1"
    local plugins=$(jq -r '.plugins[]' "$config_file" 2>/dev/null)
    
    if [ -z "$plugins" ] || [ "$plugins" == "null" ]; then
        log_warn "配置文件中没有插件信息。"
        return
    fi
    
    log_info "正在安装插件..."
    
    echo "$plugins" | while IFS= read -r plugin; do
        if [ -n "$plugin" ]; then
            log_info "安装插件: $plugin"
            vfox add "$plugin" || log_warn "安装插件 $plugin 失败"
        fi
    done
    
    log_info "插件安装完成！"
}

# 安装 SDK
install_sdks() {
    local config_file="$1"
    local sdks=$(jq -c '.sdks[]' "$config_file" 2>/dev/null)
    
    if [ -z "$sdks" ] || [ "$sdks" == "null" ]; then
        log_warn "配置文件中没有 SDK 信息。"
        return
    fi
    
    log_info "正在安装 SDK..."
    
    echo "$sdks" | while IFS= read -r sdk_json; do
        if [ -n "$sdk_json" ]; then
            sdk_name=$(echo "$sdk_json" | jq -r '.name')
            sdk_version=$(echo "$sdk_json" | jq -r '.version')
            
            if [ -n "$sdk_name" ] && [ -n "$sdk_version" ]; then
                log_info "安装 $sdk_name@$sdk_version..."
                vfox install "$sdk_name@$sdk_version" || log_warn "安装 $sdk_name@$sdk_version 失败"
            fi
        fi
    done
    
    log_info "SDK 安装完成！"
}

# 配置全局 SDK
configure_global_sdks() {
    local config_file="$1"
    local global_sdks=$(jq -c '.global_sdks[]' "$config_file" 2>/dev/null)
    
    if [ -z "$global_sdks" ] || [ "$global_sdks" == "null" ]; then
        log_warn "配置文件中没有全局 SDK 信息。"
        return
    fi
    
    log_info "配置全局 SDK..."
    
    echo "$global_sdks" | while IFS= read -r sdk_json; do
        if [ -n "$sdk_json" ]; then
            sdk_name=$(echo "$sdk_json" | jq -r '.name')
            sdk_version=$(echo "$sdk_json" | jq -r '.version')
            
            if [ -n "$sdk_name" ] && [ -n "$sdk_version" ]; then
                log_info "配置全局 $sdk_name@$sdk_version..."
                vfox use -g "$sdk_name@$sdk_version" || log_warn "配置全局 $sdk_name@$sdk_version 失败"
            fi
        fi
    done
    
    log_info "全局 SDK 配置完成！"
}

# 显示帮助信息
show_help() {
    echo "用法: $0 <配置文件路径>"
    echo ""
    echo "根据配置文件部署 VFox 环境。"
    echo ""
    echo "参数:"
    echo "  <配置文件路径>  由 collect_vfox_info.sh 生成的配置文件路径"
    echo ""
    echo "示例:"
    echo "  $0 ./vfox_config_20250611_123456.json"
}

# 主函数
main() {
    # 检查参数
    if [ $# -lt 1 ]; then
        log_error "缺少配置文件参数。"
        show_help
        exit 1
    fi
    
    local config_file="$1"
    
    # 检查 jq 是否安装
    check_jq_installed
    
    # 检查配置文件
    check_config_file "$config_file"
    
    # 显示配置信息
    local vfox_version=$(jq -r '.vfox_version' "$config_file")
    local collection_date=$(jq -r '.collection_date' "$config_file")
    local sdk_path=$(jq -r '.sdk_path' "$config_file")
    
    log_info "配置文件信息:"
    log_info "  收集日期: $collection_date"
    log_info "  VFox 版本: $vfox_version"
    log_info "  SDK 路径: $sdk_path"
    log_info "  插件数量: $(jq '.plugins | length' "$config_file")"
    log_info "  SDK 数量: $(jq '.sdks | length' "$config_file")"
    log_info "  全局 SDK 数量: $(jq '.global_sdks | length' "$config_file")"
    
    # 检查是否已安装 VFox
    if ! command -v vfox &> /dev/null; then
        install_vfox
        configure_shell
    else
        local current_version=$(vfox --version 2>/dev/null | head -n 1 | awk '{print $3}')
        log_info "已安装 VFox 版本: $current_version (配置文件版本: $vfox_version)"
    fi
    
    # 配置 SDK 路径
    configure_sdk_path "$config_file"
    
    # 安装插件
    install_plugins "$config_file"
    
    # 安装 SDK
    install_sdks "$config_file"
    
    # 配置全局 SDK
    configure_global_sdks "$config_file"
    
    log_info "===== VFox 环境配置完成 ====="
    log_info "运行 'vfox list' 查看已安装的 SDK"
}

# 执行主函数
main "$@" 