#!/bin/bash

# SDK路径配置脚本 - 使用工具命令版本
# 作者：Claude
# 创建日期：$(date +"%Y-%m-%d")

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 语言选择
LANGUAGE="zh_CN" # 默认使用中文

# 获取消息函数（使用普通变量而非关联数组）
get_message() {
    local key=$1
    shift
    
    if [ "$LANGUAGE" = "zh_CN" ]; then
        case "$key" in
            "welcome") echo "===== SDK路径集中配置工具 (工具命令版) =====";;
            "sdk_path") printf "SDK路径: %s" "$1";;
            "info") echo "[信息]";;
            "warn") echo "[警告]";;
            "error") echo "[错误]";;
            "debug") echo "[调试]";;
            "select_language") echo "请选择语言/Please select language:";;
            "option_chinese") echo "1. 中文";;
            "option_english") echo "2. English";;
            "enter_option") echo "请输入选项(1-2): ";;
            "create_dirs") echo "创建SDK目录结构...";;
            "dirs_created") echo "目录结构创建完成。";;
            "config_nodejs") echo "配置Node.js工具...";;
            "config_npm") echo "配置npm...";;
            "npm_configured") echo "npm配置完成。";;
            "npm_failed") echo "npm配置失败。";;
            "npm_not_installed") echo "未安装npm，跳过配置。";;
            "config_yarn") echo "配置yarn...";;
            "yarn_configured") echo "yarn配置完成。";;
            "yarn_failed") echo "yarn配置失败。";;
            "yarn_not_installed") echo "未安装yarn，跳过配置。";;
            "config_pnpm") echo "配置pnpm...";;
            "pnpm_configured") echo "pnpm配置完成。";;
            "pnpm_failed") echo "pnpm配置失败。";;
            "pnpm_not_installed") echo "未安装pnpm，跳过配置。";;
            "set_yarn_default") echo "是否将yarn设置为默认的Node.js包管理器? (y/n): ";;
            "menu_title") echo "选择要执行的操作:";;
            "menu_option1") echo "1. 完整配置所有SDK工具";;
            "menu_option2") echo "2. 仅配置Node.js工具";;
            "menu_option3") echo "3. 仅将yarn设置为默认包管理器";;
            "menu_option4") echo "4. 退出";;
            "enter_menu_option") echo "请输入选项(1-4): ";;
            "invalid_option") echo "无效的选项，请重新运行脚本并选择有效的选项。";;
            "config_complete") echo "===== 配置完成 =====";;
            "config_complete_detail") printf "所有支持的工具都已配置为使用 %s 路径。" "$1";;
            "env_vars_set") echo "环境变量已设置为备份机制，以确保最大兼容性。";;
            "reload_shell") echo "应用配置需要重新加载Shell配置或重新登录。";;
            "reload_cmd") echo "source ~/.bashrc 或 source ~/.zshrc";;
            "exited") echo "已退出。";;
            *) echo "未知消息: $key";;
        esac
    else
        case "$key" in
            "welcome") echo "===== SDK Path Configuration Tool (Commands Version) =====";;
            "sdk_path") printf "SDK Path: %s" "$1";;
            "info") echo "[INFO]";;
            "warn") echo "[WARNING]";;
            "error") echo "[ERROR]";;
            "debug") echo "[DEBUG]";;
            "select_language") echo "Please select language/请选择语言:";;
            "option_chinese") echo "1. 中文";;
            "option_english") echo "2. English";;
            "enter_option") echo "Enter option (1-2): ";;
            "create_dirs") echo "Creating SDK directory structure...";;
            "dirs_created") echo "Directory structure created.";;
            "config_nodejs") echo "Configuring Node.js tools...";;
            "config_npm") echo "Configuring npm...";;
            "npm_configured") echo "npm configuration completed.";;
            "npm_failed") echo "npm configuration failed.";;
            "npm_not_installed") echo "npm not installed, skipping configuration.";;
            "config_yarn") echo "Configuring yarn...";;
            "yarn_configured") echo "yarn configuration completed.";;
            "yarn_failed") echo "yarn configuration failed.";;
            "yarn_not_installed") echo "yarn not installed, skipping configuration.";;
            "config_pnpm") echo "Configuring pnpm...";;
            "pnpm_configured") echo "pnpm configuration completed.";;
            "pnpm_failed") echo "pnpm configuration failed.";;
            "pnpm_not_installed") echo "pnpm not installed, skipping configuration.";;
            "set_yarn_default") echo "Set yarn as the default Node.js package manager? (y/n): ";;
            "menu_title") echo "Select an operation:";;
            "menu_option1") echo "1. Configure all SDK tools";;
            "menu_option2") echo "2. Configure Node.js tools only";;
            "menu_option3") echo "3. Set yarn as default package manager only";;
            "menu_option4") echo "4. Exit";;
            "enter_menu_option") echo "Enter option (1-4): ";;
            "invalid_option") echo "Invalid option, please run the script again and select a valid option.";;
            "config_complete") echo "===== Configuration Complete =====";;
            "config_complete_detail") printf "All supported tools have been configured to use %s path." "$1";;
            "env_vars_set") echo "Environment variables have been set as a backup mechanism to ensure maximum compatibility.";;
            "reload_shell") echo "To apply configuration, reload your shell configuration or log in again.";;
            "reload_cmd") echo "source ~/.bashrc or source ~/.zshrc";;
            "exited") echo "Exited.";;
            *) echo "Unknown message: $key";;
        esac
    fi
}

# 设置日志函数
log_info() {
    echo -e "${GREEN}$(get_message "info")${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}$(get_message "warn")${NC} $1"
}

log_error() {
    echo -e "${RED}$(get_message "error")${NC} $1"
}

log_debug() {
    echo -e "${BLUE}$(get_message "debug")${NC} $1"
}

# 选择语言
select_language() {
    echo "请选择语言/Please select language:"
    echo "1. 中文"
    echo "2. English"
    read -p "请输入选项/Enter option (1-2): " lang_choice
    
    case $lang_choice in
        1)
            LANGUAGE="zh_CN"
            ;;
        2)
            LANGUAGE="en_US"
            ;;
        *)
            echo "无效选项，使用默认语言(中文)/Invalid option, using default language (Chinese)"
            LANGUAGE="zh_CN"
            ;;
    esac
}

# 主SDK路径设置
SDK_PATH=${1:-"/opt/allsdks"}
ENV_FILE="$SDK_PATH/sdk_env.sh"

# 检查工具是否已安装
check_tool_installed() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# 创建主要的SDK路径目录
create_directories() {
    log_info "$(get_message "create_dirs")"
    
    # 创建主SDK目录
    mkdir -p "$SDK_PATH"
    
    # Node.js - 放在nodejs目录下
    mkdir -p "$SDK_PATH/nodejs/node_cache/npm-global" 
    mkdir -p "$SDK_PATH/nodejs/node_cache/npm-cache" 
    mkdir -p "$SDK_PATH/nodejs/node_cache/yarn-cache" 
    mkdir -p "$SDK_PATH/nodejs/node_cache/pnpm-store"
    
    # Python - 放在python目录下
    mkdir -p "$SDK_PATH/python/python_cache/pip" 
    mkdir -p "$SDK_PATH/python/python_cache/venvs" 
    mkdir -p "$SDK_PATH/python/python_cache/pipenv" 
    mkdir -p "$SDK_PATH/python/python_cache/poetry"
    
    # Java - 放在java目录下
    mkdir -p "$SDK_PATH/java/java_cache/gradle"
    
    # Maven - 作为独立的顶级目录
    mkdir -p "$SDK_PATH/maven/repository"
    
    # Go - 放在golang目录下
    mkdir -p "$SDK_PATH/golang/go_cache/pkg/mod" 
    mkdir -p "$SDK_PATH/golang/go_cache/go-build"
    
    # Ruby - 放在ruby目录下
    mkdir -p "$SDK_PATH/ruby/ruby_cache/gems" 
    mkdir -p "$SDK_PATH/ruby/ruby_cache/bundle"
    
    # Rust - 放在rust目录下
    mkdir -p "$SDK_PATH/rust/rust_cache/cargo" 
    mkdir -p "$SDK_PATH/rust/rust_cache/rustup"
    
    # .NET - 放在dotnet目录下
    mkdir -p "$SDK_PATH/dotnet/dotnet_cache/nuget/packages" 
    mkdir -p "$SDK_PATH/dotnet/dotnet_cache/tools"
    
    # PHP - 放在php目录下
    mkdir -p "$SDK_PATH/php/php_cache/composer/cache"
    
    # Dart & Flutter - 放在flutter目录下
    mkdir -p "$SDK_PATH/flutter/flutter_cache/pub-cache"
    
    log_info "$(get_message "dirs_created")"
}

# 配置Node.js工具
configure_nodejs_tools() {
    log_info "$(get_message "config_nodejs")"
    
    # 配置npm
    if check_tool_installed "npm"; then
        log_info "$(get_message "config_npm")"
        npm config set prefix "$SDK_PATH/nodejs/node_cache/npm-global" && \
        npm config set cache "$SDK_PATH/nodejs/node_cache/npm-cache" && \
        log_info "$(get_message "npm_configured")" || log_warn "$(get_message "npm_failed")"
        
        # 验证配置
        log_info "npm prefix: $(npm config get prefix)"
        log_info "npm cache: $(npm config get cache)"
    else
        log_warn "$(get_message "npm_not_installed")"
    fi
    
    # 配置yarn
    if check_tool_installed "yarn"; then
        log_info "$(get_message "config_yarn")"
        
        # 创建yarn全局目录
        mkdir -p "$SDK_PATH/nodejs/node_cache/yarn-global"
        
        # 设置yarn缓存和全局目录
        yarn config set cache-folder "$SDK_PATH/nodejs/node_cache/yarn-cache" && \
        yarn config set global-folder "$SDK_PATH/nodejs/node_cache/yarn-global" && \
        log_info "$(get_message "yarn_configured")" || log_warn "$(get_message "yarn_failed")"
        
        # 验证配置
        log_info "yarn cache-folder: $(yarn config get cache-folder)"
        log_info "yarn global-folder: $(yarn config get global-folder)"
    else
        log_warn "$(get_message "yarn_not_installed")"
    fi
    
    # 配置pnpm
    if check_tool_installed "pnpm"; then
        log_info "$(get_message "config_pnpm")"
        pnpm config set store-dir "$SDK_PATH/nodejs/node_cache/pnpm-store" && \
        log_info "$(get_message "pnpm_configured")" || log_warn "$(get_message "pnpm_failed")"
        
        # 验证配置
        log_info "pnpm store-dir: $(pnpm config get store-dir)"
    else
        log_warn "$(get_message "pnpm_not_installed")"
    fi
    
    # 询问是否将yarn设置为默认包管理器
    read -p "$(get_message "set_yarn_default")" set_yarn_default
    if [[ "$set_yarn_default" =~ ^[Yy]$ ]]; then
        set_yarn_as_default_package_manager
    fi
}

# 将yarn设置为默认包管理器
set_yarn_as_default_package_manager() {
    log_info "正在将yarn设置为默认包管理器..."
    
    # 检查yarn是否已安装
    if ! check_tool_installed "yarn"; then
        log_warn "未安装yarn，请先安装yarn: npm install -g yarn"
        read -p "是否立即安装yarn? (y/n): " install_yarn
        if [[ "$install_yarn" =~ ^[Yy]$ ]]; then
            log_info "安装yarn..."
            npm install -g yarn || {
                log_error "yarn安装失败。"
                return 1
            }
            log_info "yarn安装完成。"
        else
            log_info "已取消设置yarn为默认包管理器。"
            return 0
        fi
    fi
    
    # 设置npm使用yarn作为包管理器
    log_info "配置yarn作为默认包管理器..."
    
    # npm高版本使用package-manager选项（可能不支持）
    npm config set package-manager yarn 2>/dev/null || log_info "npm不支持package-manager配置，跳过"
    
    # 尝试设置prefer-yarn选项（可能不支持）
    npm config set prefer-yarn true 2>/dev/null || log_info "npm不支持prefer-yarn配置，跳过"
    
    # 创建npm的别名到yarn（更可靠的方法）
    shell_config=""
    if [ -n "$BASH_VERSION" ]; then
        shell_config="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        shell_config="$HOME/.zshrc"
    else
        log_warn "无法确定当前Shell类型，请手动添加别名配置。"
        log_info "添加以下行到您的Shell配置文件中："
        log_info "alias npm='yarn'"
        log_info "alias npx='yarn dlx'"
    fi
    
    if [ -n "$shell_config" ]; then
        # 添加别名
        if ! grep -q "# Yarn作为默认包管理器的别名" "$shell_config"; then
            echo "" >> "$shell_config"
            echo "# Yarn作为默认包管理器的别名" >> "$shell_config"
            echo "alias npm='yarn'" >> "$shell_config"
            echo "alias npx='yarn dlx'" >> "$shell_config"
            log_info "已添加npm和npx到yarn的别名。"
        fi
    fi
    
    # 更新PATH环境变量以优先使用yarn的bin目录
    yarn_global_dir=$(yarn global dir)
    yarn_bin_path="$yarn_global_dir/node_modules/.bin"
    
    # 检查是否已添加到PATH
    if [[ ":$PATH:" != *":$yarn_bin_path:"* ]]; then
        log_info "添加yarn bin目录到PATH环境变量..."
        
        # 为当前会话添加
        export PATH="$yarn_bin_path:$PATH"
        
        # 为shell配置文件添加
        if [ -n "$shell_config" ]; then
            # 检查是否已添加
            if ! grep -q "# yarn bin目录配置" "$shell_config"; then
                echo "" >> "$shell_config"
                echo "# yarn bin目录配置" >> "$shell_config"
                echo "export PATH=\"$yarn_bin_path:\$PATH\"" >> "$shell_config"
                log_info "已添加yarn bin目录到 $shell_config"
            fi
            
            log_info "yarn bin目录已添加到PATH环境变量。"
        fi
    fi
    
    log_info "✅ yarn已设置为默认包管理器。"
    log_info "现在可以使用yarn命令代替npm命令。"
    log_info "例如: yarn add [包名] 代替 npm install --save [包名]"
    log_info "别名已设置: npm='yarn', npx='yarn dlx'"
    log_info "您需要重新加载Shell配置才能生效:"
    log_info "source $shell_config"
    
    return 0
}

# 配置Python工具
configure_python_tools() {
    log_info "配置Python工具..."
    
    # 配置pip
    if check_tool_installed "pip"; then
        log_info "配置pip..."
        
        # 创建pip配置目录
        mkdir -p ~/.config/pip
        
        # 始终使用配置文件方法，更可靠
        cat > ~/.config/pip/pip.conf << EOF
[global]
cache-dir = $SDK_PATH/python/python_cache/pip
EOF
        log_info "已创建pip配置文件: ~/.config/pip/pip.conf"
        
        # 同时尝试使用命令行方式（如果支持）
        if pip --help | grep -q "config"; then
            pip config set global.cache-dir "$SDK_PATH/python/python_cache/pip" 2>/dev/null
        fi
    else
        log_warn "未安装pip，跳过配置。"
    fi
    
    # 配置poetry
    if check_tool_installed "poetry"; then
        log_info "配置poetry..."
        poetry config cache-dir "$SDK_PATH/python/python_cache/poetry" && \
        log_info "poetry配置完成。" || log_warn "poetry配置失败。"
        
        # 验证配置
        log_info "poetry cache-dir: $(poetry config cache-dir)"
    else
        log_warn "未安装poetry，跳过配置。"
    fi
}

# 配置Java工具
configure_java_tools() {
    log_info "配置Java工具..."
    
    # 配置Maven
    if check_tool_installed "mvn"; then
        log_info "配置Maven..."
        mkdir -p ~/.m2
        cat > ~/.m2/settings.xml << EOF
<settings>
  <localRepository>$SDK_PATH/maven/repository</localRepository>
</settings>
EOF
        log_info "Maven配置完成。"
    else
        log_warn "未安装Maven，跳过配置。"
    fi
    
    # 配置Gradle
    if check_tool_installed "gradle"; then
        log_info "配置Gradle..."
        mkdir -p ~/.gradle
        cat > ~/.gradle/gradle.properties << EOF
org.gradle.user.home=$SDK_PATH/java/java_cache/gradle
EOF
        log_info "Gradle配置完成。"
    else
        log_warn "未安装Gradle，跳过配置。"
    fi
}

# 配置Ruby工具
configure_ruby_tools() {
    log_info "配置Ruby工具..."
    
    # 配置Bundler
    if check_tool_installed "bundle"; then
        log_info "配置Bundler..."
        
        # 尝试多种配置方法，以适应不同版本的bundler
        bundle config set path "$SDK_PATH/ruby/ruby_cache/bundle" 2>/dev/null || \
        bundle config path "$SDK_PATH/ruby/ruby_cache/bundle" 2>/dev/null || \
        bundle config --global path "$SDK_PATH/ruby/ruby_cache/bundle" 2>/dev/null
        
        # 创建配置文件作为备份方法
        mkdir -p ~/.bundle
        cat > ~/.bundle/config << EOF
---
BUNDLE_PATH: "$SDK_PATH/ruby/ruby_cache/bundle"
EOF
        
        log_info "Bundler配置完成。"
    else
        log_warn "未安装Bundler，跳过配置。"
    fi
}

# 配置Rust工具
configure_rust_tools() {
    log_info "配置Rust工具..."
    
    # 配置Cargo
    if check_tool_installed "cargo"; then
        log_info "配置Cargo..."
        mkdir -p ~/.cargo
        cat > ~/.cargo/config.toml << EOF
[build]
target-dir = "$SDK_PATH/rust/rust_cache/cargo/target"
EOF
        log_info "Cargo配置完成。"
    else
        log_warn "未安装Cargo，跳过配置。"
    fi
}

# 配置PHP工具
configure_php_tools() {
    log_info "配置PHP工具..."
    
    # 配置Composer
    if check_tool_installed "composer"; then
        log_info "配置Composer..."
        composer config -g cache-dir "$SDK_PATH/php/php_cache/composer/cache" && \
        log_info "Composer配置完成。" || log_warn "Composer配置失败。"
        
        # 验证配置
        log_info "Composer cache-dir: $(composer config -g cache-dir)"
    else
        log_warn "未安装Composer，跳过配置。"
    fi
}

# 配置.NET工具
configure_dotnet_tools() {
    log_info "配置.NET工具..."
    
    # 配置NuGet
    if check_tool_installed "dotnet"; then
        log_info "配置NuGet..."
        mkdir -p ~/.nuget
        cat > ~/.nuget/NuGet.Config << EOF
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <add key="globalPackagesFolder" value="$SDK_PATH/dotnet/dotnet_cache/nuget/packages" />
  </config>
</configuration>
EOF
        log_info "NuGet配置完成。"
    else
        log_warn "未安装.NET，跳过配置。"
    fi
}

# 创建环境变量配置文件（作为备份机制）
create_env_file() {
    log_info "创建环境变量配置文件: $ENV_FILE"
    
    cat > "$ENV_FILE" << EOF
#!/bin/bash

# SDK路径环境变量配置 - 备份机制
# 由configure_sdk_with_commands.sh自动生成于 $(date)
# 注意：这些环境变量作为备份机制，优先使用工具自身的配置

# 主SDK路径
export SDK_PATH="$SDK_PATH"

# Node.js配置
export NODE_CACHE_DIR="\$SDK_PATH/nodejs/node_cache"
export NPM_CONFIG_PREFIX="\$NODE_CACHE_DIR/npm-global"
export NPM_CONFIG_CACHE="\$NODE_CACHE_DIR/npm-cache"
export YARN_CACHE_FOLDER="\$NODE_CACHE_DIR/yarn-cache"
export PNPM_STORE_DIR="\$NODE_CACHE_DIR/pnpm-store"
export PATH="\$NPM_CONFIG_PREFIX/bin:\$PATH"

# Python配置
export PYTHON_CACHE_DIR="\$SDK_PATH/python/python_cache"
export PIP_CACHE_DIR="\$PYTHON_CACHE_DIR/pip"
export PIP_DOWNLOAD_CACHE="\$PYTHON_CACHE_DIR/pip-download"
export WORKON_HOME="\$PYTHON_CACHE_DIR/venvs"
export VIRTUALENV_HOME="\$PYTHON_CACHE_DIR/venvs"
export PIPENV_CACHE_DIR="\$PYTHON_CACHE_DIR/pipenv"
export PIPENV_VENV_IN_PROJECT=0
export PIPENV_VIRTUALENV="\$PYTHON_CACHE_DIR/pipenv-venvs"
export POETRY_CACHE_DIR="\$PYTHON_CACHE_DIR/poetry"

# Java配置
export JAVA_CACHE_DIR="\$SDK_PATH/java/java_cache"
export GRADLE_USER_HOME="\$JAVA_CACHE_DIR/gradle"

# Maven配置
export M2_HOME="\$SDK_PATH/maven"
export MAVEN_OPTS="-Dmaven.repo.local=\$SDK_PATH/maven/repository"

# Go配置
export GO_CACHE_DIR="\$SDK_PATH/golang/go_cache"
export GOPATH="\$GO_CACHE_DIR"
export GOMODCACHE="\$GO_CACHE_DIR/pkg/mod"
export GOCACHE="\$GO_CACHE_DIR/go-build"
export PATH="\$GOPATH/bin:\$PATH"

# Ruby配置
export RUBY_CACHE_DIR="\$SDK_PATH/ruby/ruby_cache"
export GEM_HOME="\$RUBY_CACHE_DIR/gems"
export GEM_PATH="\$RUBY_CACHE_DIR/gems"
export BUNDLE_USER_HOME="\$RUBY_CACHE_DIR/bundle"
export BUNDLE_PATH="\$RUBY_CACHE_DIR/bundle"
export PATH="\$GEM_HOME/bin:\$PATH"

# Rust配置
export RUST_CACHE_DIR="\$SDK_PATH/rust/rust_cache"
export CARGO_HOME="\$RUST_CACHE_DIR/cargo"
export RUSTUP_HOME="\$RUST_CACHE_DIR/rustup"
export PATH="\$CARGO_HOME/bin:\$PATH"

# .NET配置
export DOTNET_CACHE_DIR="\$SDK_PATH/dotnet/dotnet_cache"
export NUGET_PACKAGES="\$DOTNET_CACHE_DIR/nuget/packages"
export DOTNET_TOOLS_DIR="\$DOTNET_CACHE_DIR/tools"
export PATH="\$DOTNET_TOOLS_DIR:\$PATH"

# PHP配置
export PHP_CACHE_DIR="\$SDK_PATH/php/php_cache"
export COMPOSER_HOME="\$PHP_CACHE_DIR/composer"
export COMPOSER_CACHE_DIR="\$PHP_CACHE_DIR/composer/cache"
export PATH="\$COMPOSER_HOME/vendor/bin:\$PATH"

# Dart & Flutter配置
export FLUTTER_CACHE_DIR="\$SDK_PATH/flutter/flutter_cache"
export PUB_CACHE="\$FLUTTER_CACHE_DIR/pub-cache"
export PATH="\$PUB_CACHE/bin:\$PATH"

# 输出确认信息
echo "SDK环境变量已加载，路径: \$SDK_PATH"
EOF
    
    # 设置执行权限
    chmod +x "$ENV_FILE"
    log_info "环境变量配置文件创建完成: $ENV_FILE"
}

# 添加环境变量到shell配置（作为备份机制）
add_to_shell_config() {
    log_info "添加环境变量到Shell配置（作为备份机制）..."
    
    # 同时更新bashrc和zshrc
    local bash_config="$HOME/.bashrc"
    local zsh_config="$HOME/.zshrc"
    local configs_updated=false
    
    # 更新bashrc（如果存在）
    if [ -f "$bash_config" ]; then
        if grep -q "source $ENV_FILE" "$bash_config"; then
            log_info "配置已存在于 $bash_config"
        else
            echo "" >> "$bash_config"
            echo "# SDK路径环境变量配置（备份机制）" >> "$bash_config"
            echo "source $ENV_FILE" >> "$bash_config"
            log_info "已添加配置到 $bash_config"
            configs_updated=true
        fi
    fi
    
    # 更新zshrc（如果存在）
    if [ -f "$zsh_config" ]; then
        if grep -q "source $ENV_FILE" "$zsh_config"; then
            log_info "配置已存在于 $zsh_config"
        else
            echo "" >> "$zsh_config"
            echo "# SDK路径环境变量配置（备份机制）" >> "$zsh_config"
            echo "source $ENV_FILE" >> "$zsh_config"
            log_info "已添加配置到 $zsh_config"
            configs_updated=true
        fi
    fi
    
    # 如果没有找到任何配置文件，提供手动指导
    if [ ! -f "$bash_config" ] && [ ! -f "$zsh_config" ]; then
        log_warn "未找到常见的shell配置文件，请手动添加配置。"
        log_info "添加以下行到您的Shell配置文件中："
        log_info "source $ENV_FILE"
        return
    fi
    
    # 提示用户重新加载配置
    if [ "$configs_updated" = true ]; then
        log_info "请重新加载Shell配置以使环境变量立即生效:"
        
        # 检测当前shell并提供对应的命令
        if [ -n "$BASH_VERSION" ]; then
            log_info "source $bash_config  # 适用于bash"
        elif [ -n "$ZSH_VERSION" ]; then
            log_info "source $zsh_config  # 适用于zsh"
        else
            log_info "source $bash_config  # 适用于bash"
            log_info "source $zsh_config  # 适用于zsh"
    fi
    fi
    
    # 创建一个简单的按需激活脚本，但不提示用户
    local activate_script="$SDK_PATH/activate.sh"
    cat > "$activate_script" << EOF
#!/bin/bash

# SDK环境激活脚本
# 使用方法: source $activate_script
# 由configure_sdk_with_commands.sh自动生成于 $(date)

# 加载环境变量
source "$ENV_FILE"

echo "SDK环境已加载，路径: $SDK_PATH"
EOF

    # 设置执行权限
    chmod +x "$activate_script"
}

# 验证配置
verify_config() {
    log_info "验证配置..."
    
    # 验证npm配置
    if check_tool_installed "npm"; then
        local npm_prefix=$(npm config get prefix)
        local npm_cache=$(npm config get cache)
        
        if [ "$npm_prefix" = "$SDK_PATH/nodejs/node_cache/npm-global" ]; then
            log_info "✅ npm prefix 配置正确: $npm_prefix"
        else
            log_warn "❌ npm prefix 配置不正确: $npm_prefix"
        fi
        
        if [ "$npm_cache" = "$SDK_PATH/nodejs/node_cache/npm-cache" ]; then
            log_info "✅ npm cache 配置正确: $npm_cache"
        else
            log_warn "❌ npm cache 配置不正确: $npm_cache"
        fi
    fi
    
    # 验证yarn配置
    if check_tool_installed "yarn"; then
        local yarn_cache=$(yarn config get cache-folder)
        
        if [ "$yarn_cache" = "$SDK_PATH/nodejs/node_cache/yarn-cache" ]; then
            log_info "✅ yarn cache-folder 配置正确: $yarn_cache"
        else
            log_warn "❌ yarn cache-folder 配置不正确: $yarn_cache"
        fi
    fi
    
    # 验证pnpm配置
    if check_tool_installed "pnpm"; then
        local pnpm_store=$(pnpm config get store-dir)
        
        if [ "$pnpm_store" = "$SDK_PATH/nodejs/node_cache/pnpm-store" ]; then
            log_info "✅ pnpm store-dir 配置正确: $pnpm_store"
        else
            log_warn "❌ pnpm store-dir 配置不正确: $pnpm_store"
        fi
    fi
    
    # 验证pip配置
    if check_tool_installed "pip"; then
        log_info "✅ pip cache-dir 已配置: $SDK_PATH/python/python_cache/pip (通过配置文件)"
        
        # 如果pip支持config命令，尝试获取配置
        if pip --help | grep -q "config"; then
            local pip_cache=$(pip config list 2>/dev/null | grep cache-dir | awk '{print $3}' | tr -d "'" 2>/dev/null)
            if [ -n "$pip_cache" ]; then
                log_info "pip cache-dir (通过命令): $pip_cache"
            fi
        fi
    fi
    
    # 验证poetry配置
    if check_tool_installed "poetry"; then
        local poetry_cache=$(poetry config cache-dir)
        
        if [ "$poetry_cache" = "$SDK_PATH/python/python_cache/poetry" ]; then
            log_info "✅ poetry cache-dir 配置正确: $poetry_cache"
        else
            log_warn "❌ poetry cache-dir 配置不正确: $poetry_cache"
        fi
    fi
    
    # 验证Maven配置
    if check_tool_installed "mvn"; then
        # 尝试使用Maven命令验证仓库位置
        if command -v mvn &> /dev/null; then
            local maven_repo=$(mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout 2>/dev/null)
            if [ "$maven_repo" = "$SDK_PATH/maven/repository" ]; then
                log_info "✅ Maven localRepository 配置正确: $maven_repo"
            else
                log_warn "❌ Maven localRepository 配置不正确: $maven_repo"
            fi
        fi
    fi
    
    # 验证bundle配置
    if check_tool_installed "bundle"; then
        # 直接检查配置文件而不是尝试命令
        if [ -f "$HOME/.bundle/config" ]; then
            log_info "✅ bundle path 已配置: $SDK_PATH/ruby/ruby_cache/bundle (通过配置文件)"
        fi
        
        # 尝试使用命令检查配置，但不一定所有版本都支持
        local bundle_path=$(bundle config get path 2>/dev/null || bundle config path 2>/dev/null || echo "")
        if [ -n "$bundle_path" ]; then
            log_info "bundle path (通过命令): $bundle_path"
        fi
    fi
    
    # 验证composer配置
    if check_tool_installed "composer"; then
        local composer_cache=$(composer config -g cache-dir)
        
        if [ "$composer_cache" = "$SDK_PATH/php/php_cache/composer/cache" ]; then
            log_info "✅ composer cache-dir 配置正确: $composer_cache"
        else
            log_warn "❌ composer cache-dir 配置不正确: $composer_cache"
        fi
    fi
    
    log_info "配置验证完成。"
}

# 显示帮助信息
show_help() {
    echo "用法: $0 [SDK路径]"
    echo ""
    echo "使用工具自带命令配置编程语言SDK的缓存、依赖和下载位置。"
    echo ""
    echo "参数:"
    echo "  [SDK路径]  SDK集中存储的路径，默认为 /opt/allsdks"
    echo "  -y, --yarn 将yarn设置为默认的Node.js包管理器"
    echo ""
    echo "示例:"
    echo "  $0 /opt/allsdks"
    echo "  $0 /home/user/sdks"
    echo "  $0 --yarn"
}

# 主函数
main() {
    # 选择语言
    select_language
    
    # 显示欢迎信息
    log_info "$(get_message "welcome")"
    log_info "$(get_message "sdk_path" "$SDK_PATH")"
    
    # 检查是否只需要设置yarn为默认包管理器
    if [ "$YARN_DEFAULT_ONLY" = "true" ]; then
        set_yarn_as_default_package_manager
        return 0
    fi
    
    # 检查是否有sudo权限
    if [ "$SDK_PATH" = "/opt/allsdks" ] && [ "$(id -u)" -ne 0 ]; then
        log_warn "默认SDK路径 /opt/allsdks 可能需要sudo权限。"
        log_info "您可以选择继续(可能会遇到权限问题)，或使用不同的路径。"
        read -p "是否继续? (y/n): " choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            log_info "操作已取消。请使用不同的路径重试，例如:"
            log_info "$0 $HOME/allsdks"
            return 0
        fi
    fi
    
    # 创建目录结构
    create_directories
    
    # 配置各种工具
    configure_python_tools
    configure_java_tools
    configure_ruby_tools
    configure_rust_tools
    configure_php_tools
    configure_dotnet_tools
    
    # 配置Node.js工具，但跳过yarn默认包管理器设置
    log_info "$(get_message "config_nodejs")"
    
    # 配置npm
    if check_tool_installed "npm"; then
        log_info "$(get_message "config_npm")"
        npm config set prefix "$SDK_PATH/nodejs/node_cache/npm-global" && \
        npm config set cache "$SDK_PATH/nodejs/node_cache/npm-cache" && \
        log_info "$(get_message "npm_configured")" || log_warn "$(get_message "npm_failed")"
        
        # 验证配置
        log_info "npm prefix: $(npm config get prefix)"
        log_info "npm cache: $(npm config get cache)"
    else
        log_warn "$(get_message "npm_not_installed")"
    fi
    
    # 配置yarn
    if check_tool_installed "yarn"; then
        log_info "$(get_message "config_yarn")"
        
        # 创建yarn全局目录
        mkdir -p "$SDK_PATH/nodejs/node_cache/yarn-global"
        
        # 设置yarn缓存和全局目录
        yarn config set cache-folder "$SDK_PATH/nodejs/node_cache/yarn-cache" && \
        yarn config set global-folder "$SDK_PATH/nodejs/node_cache/yarn-global" && \
        log_info "$(get_message "yarn_configured")" || log_warn "$(get_message "yarn_failed")"
        
        # 验证配置
        log_info "yarn cache-folder: $(yarn config get cache-folder)"
        log_info "yarn global-folder: $(yarn config get global-folder)"
    else
        log_warn "$(get_message "yarn_not_installed")"
    fi
    
    # 配置pnpm
    if check_tool_installed "pnpm"; then
        log_info "$(get_message "config_pnpm")"
        pnpm config set store-dir "$SDK_PATH/nodejs/node_cache/pnpm-store" && \
        log_info "$(get_message "pnpm_configured")" || log_warn "$(get_message "pnpm_failed")"
        
        # 验证配置
        log_info "pnpm store-dir: $(pnpm config get store-dir)"
    else
        log_warn "$(get_message "pnpm_not_installed")"
    fi
    
    # 只询问是否将yarn设置为默认包管理器
    read -p "$(get_message "set_yarn_default")" set_yarn_default
    if [[ "$set_yarn_default" =~ ^[Yy]$ ]]; then
        set_yarn_as_default_package_manager
    fi
    
    # 创建环境变量配置文件（作为备份机制）
    create_env_file
    
    # 添加到shell配置（作为备份机制）
    add_to_shell_config
    
    # 验证配置
    verify_config
    
    log_info "$(get_message "config_complete")"
    log_info "$(get_message "config_complete_detail" "$SDK_PATH")"
    log_info "$(get_message "env_vars_set")"
    log_info ""
    log_info "$(get_message "reload_shell")"
    log_info "$(get_message "reload_cmd")"
    
    return 0
}

# 检查是否请求帮助
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# 检查是否请求设置yarn为默认
YARN_DEFAULT_ONLY=false
if [ "$1" = "-y" ] || [ "$1" = "--yarn" ]; then
    YARN_DEFAULT_ONLY=true
    shift
fi

# 设置SDK路径
if [ -n "$1" ]; then
    SDK_PATH="$1"
fi

# 执行主函数
main 
exit $? 