#!/bin/bash

# VFox 配置信息收集脚本
# 作者：Claude
# 创建日期：$(date +"%Y-%m-%d")

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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

# 默认不显示调试信息，除非设置了DEBUG环境变量
log_debug() {
    if [ -n "$DEBUG" ]; then
        echo -e "${BLUE}[调试]${NC} $1"
    fi
}

# 检查 VFox 是否安装
check_vfox_installed() {
    if ! command -v vfox &> /dev/null; then
        log_error "未找到 VFox 命令。请确保 VFox 已安装并添加到 PATH 中。"
        exit 1
    fi
}

# 获取 VFox 版本
get_vfox_version() {
    vfox --version 2>/dev/null | head -n 1 | awk '{print $3}'
}

# 获取 VFox 配置信息
get_vfox_config() {
    local config_file="$HOME/.version-fox/config.yaml"
    if [ -f "$config_file" ]; then
        # 获取 sdkPath，不输出日志
        local sdk_path=$(grep "sdkPath:" "$config_file" | awk '{print $2}')
        echo "$sdk_path"
    else
        # 默认路径，不输出日志
        echo "$HOME/.version-fox/sdks"
    fi
}

# 获取已安装的插件列表
get_installed_plugins() {
    # 通过列出插件目录获取已安装的插件
    if [ -d "$HOME/.version-fox/plugin" ]; then
        ls -1 "$HOME/.version-fox/plugin" | grep -v "^\..*"
    fi
}

# 从文件系统获取已安装的所有 SDK 及其版本
get_installed_sdks() {
    local sdk_path="$1"
    local result=""
    
    if [ ! -d "$sdk_path" ]; then
        log_warn "SDK 目录不存在: $sdk_path"
        return
    fi
    
    # 使用调试级别显示SDK路径信息
    log_debug "从 $sdk_path 读取已安装的 SDK"
    
    # 列出 SDK 类型目录
    for sdk_type in $(ls -1 "$sdk_path"); do
        if [ -d "$sdk_path/$sdk_type" ]; then
            # 检查是否是 VFox 插件目录（通过查看是否有 v- 开头的子目录）
            if ls -1 "$sdk_path/$sdk_type" | grep -q "^v-"; then
                log_debug "发现 SDK 类型: $sdk_type"
                
                # 列出此 SDK 类型下的所有版本（只考虑 v- 开头的目录）
                for version_dir in $(ls -1 "$sdk_path/$sdk_type" | grep "^v-"); do
                    # 提取版本号 (去掉前缀 "v-")
                    local version=${version_dir#v-}
                    log_debug "  发现版本: $version"
                    
                    # 对于没有版本号的目录，跳过
                    if [[ "$version" =~ ^[0-9] || "$version" =~ ^[a-zA-Z]+[0-9] ]]; then
                        result+="$sdk_type $version"$'\n'
                    fi
                done
            else
                log_debug "跳过非SDK目录: $sdk_type (没有v-开头的版本目录)"
            fi
        fi
    done
    
    echo "$result"
}

# 获取全局激活的 SDK 版本
get_global_sdks() {
    # 从 .tool-versions 文件读取全局 SDK 设置
    if [ -f "$HOME/.version-fox/.tool-versions" ]; then
        cat "$HOME/.version-fox/.tool-versions"
    fi
}

# 主函数
main() {
    # 检查 VFox 是否安装
    check_vfox_installed
    
    # 获取 VFox 版本
    VFOX_VERSION=$(get_vfox_version)
    log_info "VFox 版本: $VFOX_VERSION"
    
    # 获取 VFox 配置
    SDK_PATH=$(get_vfox_config)
    log_info "SDK 安装路径: $SDK_PATH"
    
    # 获取已安装的插件
    log_info "收集已安装的插件..."
    PLUGINS=$(get_installed_plugins)
    
    if [ -z "$PLUGINS" ]; then
        log_warn "未找到已安装的插件。"
    else
        log_info "已安装的插件:"
        echo "$PLUGINS" | while IFS= read -r plugin; do
            echo "  - $plugin"
        done
    fi
    
    # 获取已安装的 SDK
    log_info "收集已安装的 SDK 及版本..."
    # 关闭调试输出收集结果
    local debug_state=$DEBUG
    DEBUG=""
    SDKS=$(get_installed_sdks "$SDK_PATH")
    # 恢复调试状态
    DEBUG=$debug_state
    
    if [ -z "$SDKS" ]; then
        log_warn "未找到已安装的 SDK 版本。"
    else
        log_info "已安装的 SDK 版本:"
        echo "$SDKS" | while IFS= read -r line; do
            if [ -n "$line" ]; then
                echo "  - $line"
            fi
        done
    fi
    
    # 获取全局激活的 SDK
    log_info "收集全局激活的 SDK..."
    GLOBAL_SDKS=$(get_global_sdks)
    
    if [ -z "$GLOBAL_SDKS" ]; then
        log_warn "未找到全局激活的 SDK。"
    else
        log_info "全局激活的 SDK:"
        echo "$GLOBAL_SDKS" | while IFS= read -r line; do
            echo "  - $line"
        done
    fi
    
    # 创建配置文件
    CONFIG_FILE="./vfox_config_$(date +"%Y%m%d_%H%M%S").json"
    log_info "创建配置文件: $CONFIG_FILE"
    
    # 创建 JSON 配置文件
    cat > "$CONFIG_FILE" << EOF
{
    "vfox_version": "$VFOX_VERSION",
    "collection_date": "$(date)",
    "sdk_path": "$SDK_PATH",
    "plugins": [
EOF
    
    # 添加插件信息
    first=true
    echo "$PLUGINS" | while IFS= read -r plugin; do
        if [ -n "$plugin" ]; then
            if $first; then
                first=false
                echo "        \"$plugin\"" >> "$CONFIG_FILE"
            else
                echo "        ,\"$plugin\"" >> "$CONFIG_FILE"
            fi
        fi
    done

    cat >> "$CONFIG_FILE" << EOF
    ],
    "sdks": [
EOF
    
    # 添加 SDK 信息
    first=true
    echo "$SDKS" | while IFS= read -r line; do
        if [ -n "$line" ]; then
            sdk=$(echo "$line" | awk '{print $1}')
            version=$(echo "$line" | awk '{print $2}')
            if [ -n "$sdk" ] && [ -n "$version" ]; then
                if $first; then
                    first=false
                    echo "        {\"name\": \"$sdk\", \"version\": \"$version\"}" >> "$CONFIG_FILE"
                else
                    echo "        ,{\"name\": \"$sdk\", \"version\": \"$version\"}" >> "$CONFIG_FILE"
                fi
            fi
        fi
    done

    cat >> "$CONFIG_FILE" << EOF
    ],
    "global_sdks": [
EOF
    
    # 添加全局 SDK 信息
    first=true
    echo "$GLOBAL_SDKS" | while IFS= read -r line; do
        if [ -n "$line" ]; then
            sdk=$(echo "$line" | awk '{print $1}')
            version=$(echo "$line" | awk '{print $2}')
            if [ -n "$sdk" ] && [ -n "$version" ]; then
                if $first; then
                    first=false
                    echo "        {\"name\": \"$sdk\", \"version\": \"$version\"}" >> "$CONFIG_FILE"
                else
                    echo "        ,{\"name\": \"$sdk\", \"version\": \"$version\"}" >> "$CONFIG_FILE"
                fi
            fi
        fi
    done

    cat >> "$CONFIG_FILE" << EOF
    ]
}
EOF
    
    log_info "配置信息已保存到: $CONFIG_FILE"
    log_info "您可以使用 deploy_vfox.sh 脚本和此配置文件在其他机器上部署相同的环境。"
    log_info "部署命令: ./deploy_vfox.sh $CONFIG_FILE"
}

# 执行主函数
main 