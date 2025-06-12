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

log_debug() {
    echo -e "${BLUE}[调试]${NC} $1"
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
    log_info "创建SDK目录结构..."
    
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
    
    log_info "目录结构创建完成。"
}

# 配置Node.js工具
configure_nodejs_tools() {
    log_info "配置Node.js工具..."
    
    # 配置npm
    if check_tool_installed "npm"; then
        log_info "配置npm..."
        npm config set prefix "$SDK_PATH/nodejs/node_cache/npm-global" && \
        npm config set cache "$SDK_PATH/nodejs/node_cache/npm-cache" && \
        log_info "npm配置完成。" || log_warn "npm配置失败。"
        
        # 验证配置
        log_info "npm prefix: $(npm config get prefix)"
        log_info "npm cache: $(npm config get cache)"
    else
        log_warn "未安装npm，跳过配置。"
    fi
    
    # 配置yarn
    if check_tool_installed "yarn"; then
        log_info "配置yarn..."
        yarn config set cache-folder "$SDK_PATH/nodejs/node_cache/yarn-cache" && \
        log_info "yarn配置完成。" || log_warn "yarn配置失败。"
        
        # 验证配置
        log_info "yarn cache-folder: $(yarn config get cache-folder)"
    else
        log_warn "未安装yarn，跳过配置。"
    fi
    
    # 配置pnpm
    if check_tool_installed "pnpm"; then
        log_info "配置pnpm..."
        pnpm config set store-dir "$SDK_PATH/nodejs/node_cache/pnpm-store" && \
        log_info "pnpm配置完成。" || log_warn "pnpm配置失败。"
        
        # 验证配置
        log_info "pnpm store-dir: $(pnpm config get store-dir)"
    else
        log_warn "未安装pnpm，跳过配置。"
    fi
}

# 配置Python工具
configure_python_tools() {
    log_info "配置Python工具..."
    
    # 配置pip
    if check_tool_installed "pip"; then
        log_info "配置pip..."
        
        # 检查pip是否支持config命令
        if pip --help | grep -q "config"; then
            pip config set global.cache-dir "$SDK_PATH/python/python_cache/pip" && \
            log_info "pip配置完成。" || log_warn "pip配置失败。"
            
            # 验证配置
            log_info "pip cache-dir: $(pip config list | grep cache-dir || echo '未设置')"
        else
            # 旧版pip，使用配置文件
            mkdir -p ~/.config/pip
            cat > ~/.config/pip/pip.conf << EOF
[global]
cache-dir = $SDK_PATH/python/python_cache/pip
EOF
            log_info "已创建pip配置文件: ~/.config/pip/pip.conf"
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
        bundle config set path "$SDK_PATH/ruby/ruby_cache/bundle" && \
        log_info "Bundler配置完成。" || log_warn "Bundler配置失败。"
        
        # 验证配置
        log_info "Bundler path: $(bundle config get path)"
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
    
    # 检测当前shell
    local shell_config=""
    
    if [ -n "$BASH_VERSION" ]; then
        shell_config="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        shell_config="$HOME/.zshrc"
    else
        log_warn "无法确定当前Shell类型，请手动添加配置。"
        log_info "添加以下行到您的Shell配置文件中："
        log_info "source $ENV_FILE"
        return
    fi
    
    # 检查是否已添加
    if grep -q "source $ENV_FILE" "$shell_config"; then
        log_info "配置已存在于 $shell_config"
    else
        echo "" >> "$shell_config"
        echo "# SDK路径环境变量配置（备份机制）" >> "$shell_config"
        echo "source $ENV_FILE" >> "$shell_config"
        log_info "已添加配置到 $shell_config"
    fi
    
    log_info "请重新加载Shell配置以使环境变量生效:"
    log_info "source $shell_config"
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
    if check_tool_installed "pip" && pip --help | grep -q "config"; then
        local pip_cache=$(pip config list | grep cache-dir | awk '{print $3}' | tr -d "'")
        
        if [ "$pip_cache" = "$SDK_PATH/python/python_cache/pip" ]; then
            log_info "✅ pip cache-dir 配置正确: $pip_cache"
        else
            log_warn "❌ pip cache-dir 配置不正确: $pip_cache"
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
        local bundle_path=$(bundle config get path)
        
        if [ "$bundle_path" = "$SDK_PATH/ruby/ruby_cache/bundle" ]; then
            log_info "✅ bundle path 配置正确: $bundle_path"
        else
            log_warn "❌ bundle path 配置不正确: $bundle_path"
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
    echo ""
    echo "示例:"
    echo "  $0 /opt/allsdks"
    echo "  $0 /home/user/sdks"
}

# 主函数
main() {
    # 显示欢迎信息
    log_info "===== SDK路径集中配置工具 (工具命令版) ====="
    log_info "SDK路径: $SDK_PATH"
    
    # 创建目录结构
    create_directories
    
    # 配置各种工具
    configure_nodejs_tools
    configure_python_tools
    configure_java_tools
    configure_ruby_tools
    configure_rust_tools
    configure_php_tools
    configure_dotnet_tools
    
    # 创建环境变量配置文件（作为备份机制）
    create_env_file
    
    # 添加到shell配置（作为备份机制）
    add_to_shell_config
    
    # 验证配置
    verify_config
    
    log_info "===== 配置完成 ====="
    log_info "所有支持的工具都已配置为使用 $SDK_PATH 路径。"
    log_info "环境变量已设置为备份机制，以确保最大兼容性。"
    log_info ""
    log_info "应用配置需要重新加载Shell配置或重新登录。"
    log_info "source ~/.bashrc 或 source ~/.zshrc"
}

# 检查是否请求帮助
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# 检查是否有sudo权限
if [ "$SDK_PATH" = "/opt/allsdks" ] && [ "$(id -u)" -ne 0 ]; then
    log_warn "默认SDK路径 /opt/allsdks 可能需要sudo权限。"
    log_info "您可以选择继续(可能会遇到权限问题)，或使用不同的路径。"
    read -p "是否继续? (y/n): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        log_info "操作已取消。请使用不同的路径重试，例如:"
        log_info "$0 $HOME/allsdks"
        exit 0
    fi
fi

# 执行主函数
main 