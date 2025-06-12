#!/bin/bash

# 清理旧的SDK依赖缓存
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

# 清理前确认
confirm_cleanup() {
    read -p "是否确认清理旧的SDK缓存? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "操作已取消。"
        exit 0
    fi
}

# 清理Node.js缓存
cleanup_nodejs() {
    log_info "清理Node.js缓存..."
    
    # 清理npm缓存
    if [ -d ~/.npm ]; then
        log_warn "发现旧的npm缓存: ~/.npm"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.npm
            log_info "已清理 ~/.npm"
        else
            log_info "保留 ~/.npm"
        fi
    else
        log_info "未发现旧的npm缓存。"
    fi
    
    # 清理yarn缓存
    if [ -d ~/.yarn-cache ]; then
        log_warn "发现旧的yarn缓存: ~/.yarn-cache"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.yarn-cache
            log_info "已清理 ~/.yarn-cache"
        else
            log_info "保留 ~/.yarn-cache"
        fi
    fi
    
    if [ -d ~/.cache/yarn ]; then
        log_warn "发现旧的yarn缓存: ~/.cache/yarn"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.cache/yarn
            log_info "已清理 ~/.cache/yarn"
        else
            log_info "保留 ~/.cache/yarn"
        fi
    fi
}

# 清理Python缓存
cleanup_python() {
    log_info "清理Python缓存..."
    
    # 清理pip缓存
    if [ -d ~/.cache/pip ]; then
        log_warn "发现旧的pip缓存: ~/.cache/pip"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.cache/pip
            log_info "已清理 ~/.cache/pip"
        else
            log_info "保留 ~/.cache/pip"
        fi
    else
        log_info "未发现旧的pip缓存。"
    fi
}

# 清理Maven缓存
cleanup_maven() {
    log_info "清理Maven缓存..."
    
    # 检查Maven仓库
    if [ -d ~/.m2/repository ]; then
        log_warn "发现旧的Maven仓库: ~/.m2/repository"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.m2/repository
            log_info "已清理 ~/.m2/repository"
        else
            log_info "保留 ~/.m2/repository"
        fi
    else
        log_info "未发现旧的Maven仓库。"
    fi
}

# 清理Gradle缓存
cleanup_gradle() {
    log_info "清理Gradle缓存..."
    
    if [ -d ~/.gradle ]; then
        log_warn "发现旧的Gradle缓存: ~/.gradle"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.gradle
            log_info "已清理 ~/.gradle"
        else
            log_info "保留 ~/.gradle"
        fi
    else
        log_info "未发现旧的Gradle缓存。"
    fi
}

# 清理Go缓存
cleanup_go() {
    log_info "清理Go缓存..."
    
    if [ -d ~/go ]; then
        log_warn "发现旧的Go工作区: ~/go"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/go
            log_info "已清理 ~/go"
        else
            log_info "保留 ~/go"
        fi
    else
        log_info "未发现旧的Go工作区。"
    fi
    
    if [ -d ~/.cache/go-build ]; then
        log_warn "发现旧的Go构建缓存: ~/.cache/go-build"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.cache/go-build
            log_info "已清理 ~/.cache/go-build"
        else
            log_info "保留 ~/.cache/go-build"
        fi
    else
        log_info "未发现旧的Go构建缓存。"
    fi
}

# 清理Rust缓存
cleanup_rust() {
    log_info "清理Rust缓存..."
    
    if [ -d ~/.cargo ]; then
        log_warn "发现旧的Cargo缓存: ~/.cargo"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.cargo
            log_info "已清理 ~/.cargo"
        else
            log_info "保留 ~/.cargo"
        fi
    else
        log_info "未发现旧的Cargo缓存。"
    fi
    
    if [ -d ~/.rustup ]; then
        log_warn "发现旧的Rustup缓存: ~/.rustup"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.rustup
            log_info "已清理 ~/.rustup"
        else
            log_info "保留 ~/.rustup"
        fi
    else
        log_info "未发现旧的Rustup缓存。"
    fi
}

# 清理Composer缓存
cleanup_composer() {
    log_info "清理Composer缓存..."
    
    if [ -d ~/.composer ]; then
        log_warn "发现旧的Composer缓存: ~/.composer"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.composer
            log_info "已清理 ~/.composer"
        else
            log_info "保留 ~/.composer"
        fi
    else
        log_info "未发现旧的Composer缓存。"
    fi
}

# 清理.NET缓存
cleanup_dotnet() {
    log_info "清理.NET缓存..."
    
    if [ -d ~/.nuget ]; then
        log_warn "发现旧的NuGet缓存: ~/.nuget"
        read -p "是否清理? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf ~/.nuget
            log_info "已清理 ~/.nuget"
        else
            log_info "保留 ~/.nuget"
        fi
    else
        log_info "未发现旧的NuGet缓存。"
    fi
}

# 主函数
main() {
    log_info "===== 旧SDK缓存清理工具 ====="
    log_info "此工具将清理旧的SDK依赖缓存，这些缓存现在已被移动到新位置。"
    log_warn "清理前请确保已经运行了configure_sdk_with_commands.sh脚本。"
    
    confirm_cleanup
    
    cleanup_nodejs
    cleanup_python
    cleanup_maven
    cleanup_gradle
    cleanup_go
    cleanup_rust
    cleanup_composer
    cleanup_dotnet
    
    log_info "===== 清理完成 ====="
    log_info "所有旧的SDK缓存已经处理完毕。"
    log_info "新的缓存位置在您指定的SDK路径中。"
}

# 执行主函数
main 