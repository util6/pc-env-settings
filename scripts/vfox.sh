#!/bin/bash

# ==============================================================================
# @name: vfox.sh
# @description: 备份和恢复 vfox 管理的 SDKs。
#
# @author: Gemini
# @usage: ./scripts/vfox.sh {backup|restore}
# ==============================================================================


GREEN='\033[0;32m'
NC='\033[0m'


# --- 定义变量和路径 ---

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$( dirname "$SCRIPT_DIR" )"
VFOX_SDK_FILE_PATH="${PROJECT_DIR}/vfox-sdks.txt"

# --- 函数定义 ---

# @description: 备份 vfox 已安装的 SDK 列表
backup() {
    echo "正在备份 vfox 管理的所有已安装 SDKs 到 ${VFOX_SDK_FILE_PATH}..."

    # 确定 vfox 的根目录, 如果 VFOX_HOME 环境变量未设置, 则默认为 ~/.vfox
    local VFOX_DIR="${VFOX_HOME:-$HOME/.vfox}"
    local VFOX_INSTALLED_DIR="${VFOX_DIR}/installed"

    # 检查 'installed' 目录是否存在
    if [ ! -d "${VFOX_INSTALLED_DIR}" ]; then
        echo "信息: 未找到 vfox 安装目录 (${VFOX_INSTALLED_DIR})，跳过备份。"
        # 创建一个空文件以表示备份过程已执行, 避免恢复时出错
        touch "${VFOX_SDK_FILE_PATH}"
        return
    fi

    # 清空旧的备份文件，准备写入新内容
    > "${VFOX_SDK_FILE_PATH}"

    # 遍历 `installed` 目录下的每个 SDK 目录
    for sdk_dir in "${VFOX_INSTALLED_DIR}"/*; do
        if [ -d "${sdk_dir}" ]; then
            local sdk_name=$(basename "${sdk_dir}")
            # 遍历该 SDK 的每个版本目录
            for version_dir in "${sdk_dir}"/*; do
                if [ -d "${version_dir}" ]; then
                    local version=$(basename "${version_dir}")
                    # 将 sdk-name@version 写入文件
                    echo "${sdk_name}@${version}" >> "${VFOX_SDK_FILE_PATH}"
                fi
            done
        fi
    done

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}vfox SDKs 备份成功！已备份所有已安装版本。${NC}"
    else
        echo "vfox SDKs 备份失败。"
        exit 1
    fi
}

# @description: 从备份文件恢复 vfox SDKs
restore() {
    echo "正在从 ${VFOX_SDK_FILE_PATH} 恢复 vfox SDKs..."

    # 检查备份文件是否存在
    if [ ! -f "${VFOX_SDK_FILE_PATH}" ]; then
        echo "信息: 未找到 vfox SDK 备份文件 (${VFOX_SDK_FILE_PATH})，跳过恢复。"
        return
    fi
    
    # 检查 vfox 命令是否存在
    if ! command -v vfox &> /dev/null; then
        echo "错误: vfox 命令未找到。请确保 vfox 已正确安装并已添加到 PATH。"
        exit 1
    fi

    # 逐行读取备份文件并安装
    while IFS= read -r sdk || [ -n "$sdk" ]; do
        if [ -z "$sdk" ]; then
            continue
        fi
        
        # 解析 sdk 名称和版本
        local sdk_name=$(echo "$sdk" | cut -d'@' -f1)
        
        echo "正在处理: $sdk"
        
        # 1. 添加插件 (vfox add 是幂等的, 如果已存在不会报错)
        echo "  -> 步骤 1/2: 添加插件 '${sdk_name}'..."
        vfox add "${sdk_name}"
        
        # 2. 安装指定版本
        echo "  -> 步骤 2/2: 安装版本 '${sdk}'..."
        vfox install "$sdk"
        
        if [ $? -ne 0 ]; then
            echo "警告: 安装 '$sdk' 失败。请检查网络或稍后手动安装。"
        fi

    done < "${VFOX_SDK_FILE_PATH}"
    
    echo -e "${GREEN}vfox SDKs 恢复完成！${NC}"
}

# --- 主逻辑 ---
if [ "$1" == "backup" ]; then
    backup
elif [ "$1" == "restore" ]; then
    restore
else
    echo "使用方法: $0 {backup|restore}"
    exit 1
fi 