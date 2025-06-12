#!/bin/bash

# ==============================================================================
# @name: backup.sh
# @description: 备份本机环境配置。
#              目前支持:
#              - Homebrew 软件包 (生成 Brewfile)
#
# @usage: ./scripts/backup.sh
# ==============================================================================

# --- 定义变量和路径 ---
GREEN='\033[0;32m'
NC='\033[0m'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$( dirname "$( dirname "$SCRIPT_DIR" )" )"
BREWFILE_PATH="${SCRIPT_DIR}/Brewfile"

# --- 备份 Homebrew ---
echo "正在备份 Homebrew 软件包..."
# 使用 brew bundle dump 命令创建软件包列表文件。--force 选项会覆盖已存在的 Brewfile。
brew bundle dump --file="${BREWFILE_PATH}" --force
if [ $? -ne 0 ]; then
    echo "备份失败：'brew bundle dump' 命令执行出错。"
    exit 1
fi

echo "正在从 Brewfile 中移除 VS Code 插件 (这部分由 VS Code 设置同步功能处理)..."
# 使用 grep -v 过滤掉所有以 'vscode' 开头的行，并将结果存入一个临时文件，然后替换原文件。
grep -v '^vscode' "${BREWFILE_PATH}" > "${BREWFILE_PATH}.tmp" && mv "${BREWFILE_PATH}.tmp" "${BREWFILE_PATH}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Homebrew 备份成功！已排除 VS Code 插件。${NC}"
else
    echo "从 Brewfile 中移除 VS Code 插件失败。"
    exit 1
fi

# --- 备份 vfox SDKs ---
# echo -e "\n--- 正在执行 vfox 备份 ---"
# bash "${PROJECT_DIR}/vfox-env-manager.sh" backup
# 注：vfox-env-manager.sh 脚本不存在，暂时注释掉

echo -e "\n${GREEN}所有备份任务完成！${NC}" 