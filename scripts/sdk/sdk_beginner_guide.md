# SDK配置新手指南

## 简介

当你开始学习编程时，会安装各种SDK（软件开发工具包）。这些SDK会在你的电脑上占用大量空间，并且默认情况下会分散在不同位置。本指南将帮助你：

1. 了解各种SDK的默认存储位置
2. 学习如何更改这些位置，集中管理所有SDK
3. 配置常用的SDK选项，提高开发效率

## 为什么要配置SDK存储位置？

- **节省系统盘空间**：SDK通常会下载到系统盘，容易导致空间不足
- **便于备份**：集中存储便于一次性备份所有SDK
- **跨设备同步**：可以将SDK放在外部驱动器上在多台电脑间共享
- **清理更容易**：不再需要时，可以轻松删除所有SDK

## 常用SDK配置指南

### Node.js (JavaScript/TypeScript)

**安装后需要配置的常用选项：**

1. **全局模块安装位置**：默认安装在系统目录，需要管理员权限
2. **npm缓存位置**：存储下载的包，可能占用大量空间
3. **包管理器选择**：npm、yarn或pnpm

**配置命令：**

```bash
# 查看当前npm全局安装位置
npm config get prefix

# 更改npm全局安装位置
npm config set prefix "/自定义路径/node/global"

# 更改npm缓存位置
npm config set cache "/自定义路径/node/cache"

# 如果使用yarn，设置缓存位置
yarn config set cache-folder "/自定义路径/yarn/cache"

# 如果使用pnpm，设置存储位置
pnpm config set store-dir "/自定义路径/pnpm/store"
```

**重要提示：**
- 更改全局安装位置后，需要将新路径添加到PATH环境变量
- 全局安装的工具会在`/自定义路径/node/global/bin`目录下

### Python

**安装后需要配置的常用选项：**

1. **pip缓存位置**：存储下载的包
2. **虚拟环境位置**：隔离不同项目的依赖
3. **包管理工具选择**：pip、pipenv、poetry等

**配置命令：**

```bash
# 更改pip缓存位置
pip config set global.cache-dir "/自定义路径/python/pip-cache"

# 设置虚拟环境位置（适用于virtualenv/venv）
export WORKON_HOME="/自定义路径/python/venvs"

# 如果使用pipenv，设置虚拟环境位置
export PIPENV_VENV_IN_PROJECT=0
export PIPENV_VIRTUALENV="/自定义路径/python/pipenv-venvs"

# 如果使用poetry，设置缓存位置
poetry config cache-dir "/自定义路径/python/poetry-cache"
```

**重要提示：**
- Python虚拟环境可以帮助避免包冲突问题
- 建议为每个项目创建单独的虚拟环境

### Java

**安装后需要配置的常用选项：**

1. **Maven本地仓库**：存储下载的依赖
2. **Gradle缓存**：Gradle构建工具的缓存
3. **JDK版本管理**：多个JDK版本共存

**配置命令：**

```bash
# 设置Maven本地仓库位置（创建settings.xml）
mkdir -p ~/.m2
cat > ~/.m2/settings.xml << EOF
<settings>
  <localRepository>/自定义路径/java/maven-repo</localRepository>
</settings>
EOF

# 设置Gradle用户主目录
export GRADLE_USER_HOME="/自定义路径/java/gradle"

# 也可以创建gradle.properties文件
mkdir -p ~/.gradle
echo "org.gradle.user.home=/自定义路径/java/gradle" > ~/.gradle/gradle.properties
```

**重要提示：**
- Maven仓库可能会非常大，定期清理很重要
- 使用SDKMAN!等工具可以管理多个JDK版本

### Go

**安装后需要配置的常用选项：**

1. **GOPATH**：工作区和依赖存储位置
2. **Go Modules缓存**：存储下载的模块
3. **Go构建缓存**：编译缓存

**配置命令：**

```bash
# 设置GOPATH（工作区和依赖）
export GOPATH="/自定义路径/go/workspace"

# 设置Go Modules缓存
export GOMODCACHE="/自定义路径/go/pkg/mod"

# 设置Go构建缓存
export GOCACHE="/自定义路径/go/build-cache"
```

**重要提示：**
- Go 1.11以后推荐使用Go Modules而不是GOPATH
- 将`$GOPATH/bin`添加到PATH环境变量可以使用go install安装的工具

### Rust

**安装后需要配置的常用选项：**

1. **Cargo主目录**：包含配置、缓存和编译产物
2. **Rustup工具链**：管理Rust版本

**配置命令：**

```bash
# 设置Cargo主目录
export CARGO_HOME="/自定义路径/rust/cargo"

# 设置Rustup工具链目录
export RUSTUP_HOME="/自定义路径/rust/rustup"

# 可以创建配置文件设置编译目标目录
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << EOF
[build]
target-dir = "/自定义路径/rust/target"
EOF
```

**重要提示：**
- Cargo编译产物可能非常大，定期清理target目录
- 将`$CARGO_HOME/bin`添加到PATH环境变量

### Ruby

**安装后需要配置的常用选项：**

1. **Gem安装位置**：Ruby包安装位置
2. **Bundler配置**：项目依赖管理

**配置命令：**

```bash
# 设置Gem安装位置
export GEM_HOME="/自定义路径/ruby/gems"
export GEM_PATH="/自定义路径/ruby/gems"

# 设置Bundler路径
bundle config set path "/自定义路径/ruby/bundle"
```

**重要提示：**
- 将`$GEM_HOME/bin`添加到PATH环境变量
- RVM或rbenv可以帮助管理多个Ruby版本

### PHP

**安装后需要配置的常用选项：**

1. **Composer缓存**：PHP包管理器的缓存

**配置命令：**

```bash
# 设置Composer缓存目录
composer config -g cache-dir "/自定义路径/php/composer-cache"

# 设置Composer主目录
export COMPOSER_HOME="/自定义路径/php/composer"
```

**重要提示：**
- 将`$COMPOSER_HOME/vendor/bin`添加到PATH环境变量

### .NET

**安装后需要配置的常用选项：**

1. **NuGet包缓存**：.NET包管理器的缓存
2. **全局工具安装位置**：dotnet工具的安装位置

**配置命令：**

```bash
# 设置NuGet包缓存位置
export NUGET_PACKAGES="/自定义路径/dotnet/nuget-packages"

# 设置.NET工具目录
export DOTNET_TOOLS_DIR="/自定义路径/dotnet/tools"
```

**重要提示：**
- 将工具目录添加到PATH环境变量

## 一键配置脚本

我们提供了一个简单的脚本，可以帮助你一次性配置所有SDK的存储位置：

```bash
# 下载配置脚本
curl -O https://raw.githubusercontent.com/yourusername/sdk-config/main/configure_sdk_paths.sh

# 赋予执行权限
chmod +x configure_sdk_paths.sh

# 运行脚本（使用默认路径/opt/allsdks）
./configure_sdk_paths.sh

# 或者指定自定义路径
./configure_sdk_paths.sh /home/yourusername/sdks
```

## 常见问题

### 1. 更改SDK位置后，旧的缓存还在吗？

更改位置后，新的包会下载到新位置，但旧的缓存仍然存在。你可以手动删除旧的缓存目录。

### 2. 如何确认配置已生效？

大多数工具提供命令查看当前配置：

```bash
# npm配置
npm config get prefix
npm config get cache

# pip配置
pip config list

# Maven配置
mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout
```

### 3. 我的系统盘空间不足，哪些SDK占用空间最大？

通常占用空间最大的SDK缓存有：
- Node.js的npm和yarn缓存
- Maven本地仓库
- Docker镜像（如果使用Docker）
- Gradle缓存

### 4. 我可以将SDK放在外部硬盘上吗？

可以，但要注意：
- 确保外部硬盘在使用SDK时始终连接
- 性能可能会受到影响，特别是使用USB 2.0接口时
- 配置PATH环境变量指向外部硬盘上的可执行文件

## 环境变量持久化

要使配置永久生效，需要将环境变量添加到shell配置文件中：

**Bash用户** (~/.bashrc):
```bash
# SDK路径配置
export SDK_PATH="/自定义路径"

# Node.js
export NPM_CONFIG_PREFIX="$SDK_PATH/node/global"
export NPM_CONFIG_CACHE="$SDK_PATH/node/cache"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

# 其他SDK配置...
```

**Zsh用户** (~/.zshrc):
```bash
# 与Bash相同的配置
```

**Windows用户**:
- 在"系统属性" > "环境变量"中设置
- 为每个SDK配置单独的环境变量
- 更新PATH变量包含SDK的bin目录

## 总结

配置SDK存储位置是提高开发效率的重要步骤。通过集中管理所有SDK，你可以：
- 节省系统盘空间
- 更容易备份和迁移开发环境
- 在多台设备间共享SDK
- 更好地管理和清理缓存

记得定期清理不再需要的SDK和缓存，以释放磁盘空间。 