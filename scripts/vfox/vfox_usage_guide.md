# VFox 使用指南

## 简介

VFox 是一个跨平台的SDK版本管理工具，类似于nvm、fvm、sdkman等，支持通过插件系统管理多种编程语言的SDK版本，并且可以在Windows、Linux和macOS上工作。

## 目录结构

VFox的主要目录结构如下：

- `~/.version-fox/` - VFox主目录
  - `plugin/` - 插件目录
  - `config.yaml` - 配置文件
  - `.tool-versions` - 全局激活的SDK版本配置

- SDK安装目录 (在config.yaml的sdkPath字段中定义，默认为`/opt/allsdks`)
  - `[语言名称]/` - 例如 `nodejs/`, `python/`
    - `v-[版本号]/` - 以`v-`开头的目录，例如`v-22.16.0/`

## 常用命令

### 基本命令

```bash
# 查看VFox版本
vfox --version

# 查看帮助
vfox --help

# 列出所有安装的SDK
vfox list

# 列出特定插件的SDK版本
vfox list nodejs
```

### 插件管理

```bash
# 添加插件
vfox add nodejs

# 列出所有插件
vfox plugin list

# 删除插件
vfox plugin remove nodejs
```

### SDK管理

```bash
# 安装特定版本的SDK
vfox install nodejs@22.16.0

# 全局使用特定版本
vfox use -g nodejs@22.16.0

# 特定项目使用特定版本 (在项目目录下)
vfox use nodejs@22.16.0

# 卸载特定版本
vfox uninstall nodejs@22.16.0
```

## 备份与恢复

本项目提供了两个脚本用于备份和恢复VFox环境：

1. `collect_vfox_info.sh` - 收集VFox配置信息并生成JSON配置文件
2. `deploy_vfox.sh` - 根据JSON配置文件部署VFox环境

### 备份步骤

```bash
# 收集VFox配置信息
./collect_vfox_info.sh
```

### 恢复步骤

```bash
# 根据配置文件部署VFox环境
./deploy_vfox.sh ./vfox_config_YYYYMMDD_HHMMSS.json
``` 