#!/bin/bash

# ==============================================================================
# @name: restore.sh
# @description: 在新机器上恢复环境配置。
#              目前支持:
#              - Homebrew 软件包 (从 Brewfile 安装)
#
# @usage: ./scripts/restore.sh
# ==============================================================================

# --- 定义变量和路径 ---
GREEN='\033[0;32m'
NC='\033[0m'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$( dirname "$SCRIPT_DIR" )"
BREWFILE_PATH="${PROJECT_DIR}/Brewfile"

# --- 恢复 Homebrew ---
echo "正在恢复 Homebrew 软件包..."
# 检查 Brewfile 是否存在
if [ ! -f "${BREWFILE_PATH}" ]; then
    echo "错误：Brewfile 未在 ${BREWFILE_PATH} 找到。请确保已在源机器上运行备份脚本。"
    exit 1
fi
# 使用 brew bundle install 命令来安装 Brewfile 中定义的所有软件包。
brew bundle install --file="${BREWFILE_PATH}"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Homebrew 恢复成功！${NC}"
else
    echo "Homebrew 恢复失败。"
    exit 1
fi

echo -e "\n${GREEN}所有恢复任务完成！${NC}" 