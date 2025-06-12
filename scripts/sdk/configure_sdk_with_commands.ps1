# SDK路径配置脚本 - PowerShell版本
# 作者：Claude
# 创建日期：$(Get-Date -Format "yyyy-MM-dd")













# 主SDK路径设置
$script:SDK_PATH = if ($args[0]) { $args[0] } else { "E:\AllSDKs" }
$script:ENV_FILE = Join-Path $script:SDK_PATH "sdk_env.ps1"

# 设置语言
$script:LANGUAGE = "zh_CN" # 默认使用中文

# 语言字符串
$script:MSG_ZH = @{}
$script:MSG_EN = @{}

# 初始化中文消息
function Initialize-ChineseMessages {
    $script:MSG_ZH["welcome"] = "===== SDK路径集中配置工具 (PowerShell版) ====="
    $script:MSG_ZH["sdk_path"] = "SDK路径: {0}"
    $script:MSG_ZH["info"] = "[信息]"
    $script:MSG_ZH["warn"] = "[警告]"
    $script:MSG_ZH["error"] = "[错误]"
    $script:MSG_ZH["debug"] = "[调试]"
    $script:MSG_ZH["select_language"] = "请选择语言/Please select language:"
    $script:MSG_ZH["option_chinese"] = "1. 中文"
    $script:MSG_ZH["option_english"] = "2. English"
    $script:MSG_ZH["enter_option"] = "请输入选项/Enter option (1-2): "
    $script:MSG_ZH["create_dirs"] = "创建SDK目录结构..."
    $script:MSG_ZH["dirs_created"] = "目录结构创建完成。"
    $script:MSG_ZH["config_nodejs"] = "配置Node.js工具..."
    $script:MSG_ZH["config_npm"] = "配置npm..."
    $script:MSG_ZH["npm_configured"] = "npm配置完成。"
    $script:MSG_ZH["npm_failed"] = "npm配置失败。"
    $script:MSG_ZH["npm_not_installed"] = "未安装npm，跳过配置。"
    $script:MSG_ZH["config_yarn"] = "配置yarn..."
    $script:MSG_ZH["yarn_configured"] = "yarn配置完成。"
    $script:MSG_ZH["yarn_failed"] = "yarn配置失败。"
    $script:MSG_ZH["yarn_not_installed"] = "未安装yarn，跳过配置。"
    $script:MSG_ZH["config_pnpm"] = "配置pnpm..."
    $script:MSG_ZH["pnpm_configured"] = "pnpm配置完成。"
    $script:MSG_ZH["pnpm_failed"] = "pnpm配置失败。"
    $script:MSG_ZH["pnpm_not_installed"] = "未安装pnpm，跳过配置。"
    $script:MSG_ZH["set_yarn_default"] = "是否将yarn设置为默认的Node.js包管理器? (y/n): "
    $script:MSG_ZH["menu_title"] = "选择要执行的操作:"
    $script:MSG_ZH["menu_option1"] = "1. 完整配置所有SDK工具"
    $script:MSG_ZH["menu_option2"] = "2. 仅配置Node.js工具"
    $script:MSG_ZH["menu_option3"] = "3. 仅将yarn设置为默认包管理器"
    $script:MSG_ZH["menu_option4"] = "4. 退出"
    $script:MSG_ZH["enter_menu_option"] = "请输入选项(1-4): "
    $script:MSG_ZH["invalid_option"] = "无效的选项，请重新运行脚本并选择有效的选项。"
    $script:MSG_ZH["config_complete"] = "===== 配置完成 ====="
    $script:MSG_ZH["config_complete_detail"] = "所有支持的工具都已配置为使用 {0} 路径。"
    $script:MSG_ZH["env_vars_set"] = "环境变量已设置为备份机制，以确保最大兼容性。"
    $script:MSG_ZH["reload_shell"] = "应用配置需要重新加载PowerShell配置或重新登录。"
    $script:MSG_ZH["reload_cmd"] = ". $PROFILE"
    $script:MSG_ZH["exited"] = "已退出。"
}

# 初始化英文消息
function Initialize-EnglishMessages {
    $script:MSG_EN["welcome"] = "===== SDK Path Configuration Tool (PowerShell Version) ====="
    $script:MSG_EN["sdk_path"] = "SDK Path: {0}"
    $script:MSG_EN["info"] = "[INFO]"
    $script:MSG_EN["warn"] = "[WARNING]"
    $script:MSG_EN["error"] = "[ERROR]"
    $script:MSG_EN["debug"] = "[DEBUG]"
    $script:MSG_EN["select_language"] = "Please select language/请选择语言:"
    $script:MSG_EN["option_chinese"] = "1. 中文"
    $script:MSG_EN["option_english"] = "2. English"
    $script:MSG_EN["enter_option"] = "Enter option (1-2): "
    $script:MSG_EN["create_dirs"] = "Creating SDK directory structure..."
    $script:MSG_EN["dirs_created"] = "Directory structure created."
    $script:MSG_EN["config_nodejs"] = "Configuring Node.js tools..."
    $script:MSG_EN["config_npm"] = "Configuring npm..."
    $script:MSG_EN["npm_configured"] = "npm configuration completed."
    $script:MSG_EN["npm_failed"] = "npm configuration failed."
    $script:MSG_EN["npm_not_installed"] = "npm not installed, skipping configuration."
    $script:MSG_EN["config_yarn"] = "Configuring yarn..."
    $script:MSG_EN["yarn_configured"] = "yarn configuration completed."
    $script:MSG_EN["yarn_failed"] = "yarn configuration failed."
    $script:MSG_EN["yarn_not_installed"] = "yarn not installed, skipping configuration."
    $script:MSG_EN["config_pnpm"] = "Configuring pnpm..."
    $script:MSG_EN["pnpm_configured"] = "pnpm configuration completed."
    $script:MSG_EN["pnpm_failed"] = "pnpm configuration failed."
    $script:MSG_EN["pnpm_not_installed"] = "pnpm not installed, skipping configuration."
    $script:MSG_EN["set_yarn_default"] = "Set yarn as the default Node.js package manager? (y/n): "
    $script:MSG_EN["menu_title"] = "Select an operation:"
    $script:MSG_EN["menu_option1"] = "1. Configure all SDK tools"
    $script:MSG_EN["menu_option2"] = "2. Configure Node.js tools only"
    $script:MSG_EN["menu_option3"] = "3. Set yarn as default package manager only"
    $script:MSG_EN["menu_option4"] = "4. Exit"
    $script:MSG_EN["enter_menu_option"] = "Enter option (1-4): "
    $script:MSG_EN["invalid_option"] = "Invalid option, please run the script again and select a valid option."
    $script:MSG_EN["config_complete"] = "===== Configuration Complete ====="
    $script:MSG_EN["config_complete_detail"] = "All supported tools have been configured to use {0} path."
    $script:MSG_EN["env_vars_set"] = "Environment variables have been set as a backup mechanism to ensure maximum compatibility."
    $script:MSG_EN["reload_shell"] = "To apply configuration, reload your PowerShell profile or log in again."
    $script:MSG_EN["reload_cmd"] = ". $PROFILE"
    $script:MSG_EN["exited"] = "Exited."
}

# 获取消息
function Get-Message {
    param (
        [string]$Key,
        [array]$Args = @()
    )
    
    if ($script:LANGUAGE -eq "zh_CN") {
        $message = $script:MSG_ZH[$Key]
    } else {
        $message = $script:MSG_EN[$Key]
    }
    
    # 如果有格式化参数，应用它们
    if ($Args.Count -gt 0) {
        return $message -f $Args
    } else {
        return $message
    }
}

# 选择语言
function Select-Language {
    # 初始化所有语言的消息
    Initialize-ChineseMessages
    Initialize-EnglishMessages
    
    Write-Host "请选择语言/Please select language:"
    Write-Host "1. 中文"
    Write-Host "2. English"
    $langChoice = Read-Host "请输入选项/Enter option (1-2)"
    
    switch ($langChoice) {
        "1" {
            $script:LANGUAGE = "zh_CN"
        }
        "2" {
            $script:LANGUAGE = "en_US"
        }
        default {
            Write-Host "无效选项，使用默认语言(中文)/Invalid option, using default language (Chinese)"
            $script:LANGUAGE = "zh_CN"
        }
    }
}

# 设置日志函数
function Log-Info {
    param([string]$Message)
    Write-Host "$([char]0x1b)[32m$(Get-Message -Key "info")$([char]0x1b)[0m $Message"
}

function Log-Warn {
    param([string]$Message)
    Write-Host "$([char]0x1b)[33m$(Get-Message -Key "warn")$([char]0x1b)[0m $Message"
}

function Log-Error {
    param([string]$Message)
    Write-Host "$([char]0x1b)[31m$(Get-Message -Key "error")$([char]0x1b)[0m $Message" -ForegroundColor Red
}

function Log-Debug {
    param([string]$Message)
    Write-Host "$([char]0x1b)[34m$(Get-Message -Key "debug")$([char]0x1b)[0m $Message"
}



# 检查工具是否已安装
function Test-ToolInstalled {
    param ([string]$ToolName)
    
    $command = Get-Command $ToolName -ErrorAction SilentlyContinue
    return ($null -ne $command)
}

# 创建主要的SDK路径目录
function New-Directories {
    Log-Info $(Get-Message -Key "create_dirs")
    
    # 创建主SDK目录
    New-Item -Path $script:SDK_PATH -ItemType Directory -Force | Out-Null
    
    # Node.js - 放在nodejs目录下
    New-Item -Path "$script:SDK_PATH\nodejs\node_cache\npm-global" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\nodejs\node_cache\npm-cache" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\nodejs\node_cache\yarn-cache" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\nodejs\node_cache\yarn-global" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\nodejs\node_cache\pnpm-store" -ItemType Directory -Force | Out-Null
    
    # Python - 放在python目录下
    New-Item -Path "$script:SDK_PATH\python\python_cache\pip" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\python\python_cache\venvs" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\python\python_cache\pipenv" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\python\python_cache\poetry" -ItemType Directory -Force | Out-Null
    
    # Java - 放在java目录下
    New-Item -Path "$script:SDK_PATH\java\java_cache\gradle" -ItemType Directory -Force | Out-Null
    
    # Maven - 作为独立的顶级目录
    New-Item -Path "$script:SDK_PATH\maven\repository" -ItemType Directory -Force | Out-Null
    
    # Go - 放在golang目录下
    New-Item -Path "$script:SDK_PATH\golang\go_cache\pkg\mod" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\golang\go_cache\go-build" -ItemType Directory -Force | Out-Null
    
    # Ruby - 放在ruby目录下
    New-Item -Path "$script:SDK_PATH\ruby\ruby_cache\gems" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\ruby\ruby_cache\bundle" -ItemType Directory -Force | Out-Null
    
    # Rust - 放在rust目录下
    New-Item -Path "$script:SDK_PATH\rust\rust_cache\cargo" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\rust\rust_cache\rustup" -ItemType Directory -Force | Out-Null
    
    # .NET - 放在dotnet目录下
    New-Item -Path "$script:SDK_PATH\dotnet\dotnet_cache\nuget\packages" -ItemType Directory -Force | Out-Null
    New-Item -Path "$script:SDK_PATH\dotnet\dotnet_cache\tools" -ItemType Directory -Force | Out-Null
    
    # PHP - 放在php目录下
    New-Item -Path "$script:SDK_PATH\php\php_cache\composer\cache" -ItemType Directory -Force | Out-Null
    
    # Dart & Flutter - 放在flutter目录下
    New-Item -Path "$script:SDK_PATH\flutter\flutter_cache\pub-cache" -ItemType Directory -Force | Out-Null
    
    Log-Info $(Get-Message -Key "dirs_created")
}

# 配置Node.js工具
function Configure-NodejsTools {
    Log-Info $(Get-Message -Key "config_nodejs")
    
    # 配置npm
    if (Test-ToolInstalled "npm") {
        Log-Info $(Get-Message -Key "config_npm")
        try {
            npm config set prefix "$script:SDK_PATH\nodejs\node_cache\npm-global"
            npm config set cache "$script:SDK_PATH\nodejs\node_cache\npm-cache"
            Log-Info $(Get-Message -Key "npm_configured")
            
            # 验证配置
            Log-Info "npm prefix: $(npm config get prefix)"
            Log-Info "npm cache: $(npm config get cache)"
        } catch {
            Log-Warn $(Get-Message -Key "npm_failed")
        }
    } else {
        Log-Warn $(Get-Message -Key "npm_not_installed")
    }
    
    # 配置yarn
    if (Test-ToolInstalled "yarn") {
        Log-Info $(Get-Message -Key "config_yarn")
        try {
            # 创建yarn全局目录
            New-Item -Path "$script:SDK_PATH\nodejs\node_cache\yarn-global" -ItemType Directory -Force | Out-Null
            
            # 设置yarn缓存和全局目录
            yarn config set cache-folder "$script:SDK_PATH\nodejs\node_cache\yarn-cache"
            yarn config set global-folder "$script:SDK_PATH\nodejs\node_cache\yarn-global"
            Log-Info $(Get-Message -Key "yarn_configured")
            
            # 验证配置
            Log-Info "yarn cache-folder: $(yarn config get cache-folder)"
            Log-Info "yarn global-folder: $(yarn config get global-folder)"
        } catch {
            Log-Warn $(Get-Message -Key "yarn_failed")
        }
    } else {
        Log-Warn $(Get-Message -Key "yarn_not_installed")
    }
    
    # 配置pnpm
    if (Test-ToolInstalled "pnpm") {
        Log-Info $(Get-Message -Key "config_pnpm")
        try {
            pnpm config set store-dir "$script:SDK_PATH\nodejs\node_cache\pnpm-store"
            Log-Info $(Get-Message -Key "pnpm_configured")
            
            # 验证配置
            Log-Info "pnpm store-dir: $(pnpm config get store-dir)"
        } catch {
            Log-Warn $(Get-Message -Key "pnpm_failed")
        }
    } else {
        Log-Warn $(Get-Message -Key "pnpm_not_installed")
    }
    
    # 询问是否将yarn设置为默认包管理器
    $setYarnDefault = Read-Host $(Get-Message -Key "set_yarn_default")
    if ($setYarnDefault -eq "y" -or $setYarnDefault -eq "Y") {
        Set-YarnAsDefaultPackageManager
    }
}

# 将yarn设置为默认包管理器
function Set-YarnAsDefaultPackageManager {
    Log-Info "正在将yarn设置为默认包管理器..."
    
    if (-not (Test-ToolInstalled "yarn")) {
        Log-Warn "未安装yarn，请先安装yarn: npm install -g yarn"
        $installYarn = Read-Host "是否立即安装yarn? (y/n)"
        if ($installYarn -eq "y" -or $installYarn -eq "Y") {
            try {
                Log-Info "安装yarn..."
                npm install -g yarn
                Log-Info "yarn安装完成。"
            } catch {
                Log-Error "yarn安装失败: $_"
                return
            }
        } else {
            Log-Info "已取消设置yarn为默认包管理器。"
            return
        }
    }
    
    try {
        # 设置npm使用yarn作为包管理器（尝试高版本npm配置，可能不支持）
        Log-Info "配置yarn作为默认包管理器..."
        
        try {
            npm config set package-manager yarn 2>$null
            Log-Info "npm package-manager已设置为yarn。"
        } catch {
            Log-Info "npm不支持package-manager配置，跳过。"
        }
        
        try {
            npm config set prefer-yarn true 2>$null
            Log-Info "npm prefer-yarn已设置为true。"
        } catch {
            Log-Info "npm不支持prefer-yarn配置，跳过。"
        }
        
        # 创建PowerShell函数替代npm (更可靠的方法)
        Log-Info "创建PowerShell函数替代npm..."
        
        # 检查PowerShell配置文件是否存在，如果不存在则创建
        if (-not (Test-Path $PROFILE)) {
            New-Item -Path $PROFILE -ItemType File -Force | Out-Null
            Log-Info "已创建PowerShell配置文件: $PROFILE"
        }
        
        # 检查是否已添加
        $profileContent = Get-Content -Path $PROFILE -Raw -ErrorAction SilentlyContinue
        
        if (-not $profileContent -or -not ($profileContent -match "# Yarn作为默认包管理器的函数")) {
            Add-Content -Path $PROFILE -Value @"

# Yarn作为默认包管理器的函数
function global:npm { yarn `$args }
function global:npx { yarn dlx `$args }
"@
            Log-Info "已添加npm和npx到yarn的函数别名。"
        }
        
        # 更新PATH环境变量以优先使用yarn的bin目录
        $yarnGlobalDir = yarn global dir
        $yarnBinPath = Join-Path $yarnGlobalDir "node_modules\.bin"
        
        # 检查是否已添加到PATH
        if (-not $env:PATH.Contains($yarnBinPath)) {
            Log-Info "添加yarn bin目录到PATH环境变量..."
            
            # 为当前会话添加
            $env:PATH = "$yarnBinPath;$env:PATH"
            
            # 永久添加到用户PATH
            [Environment]::SetEnvironmentVariable(
                "PATH", 
                "$yarnBinPath;" + [Environment]::GetEnvironmentVariable("PATH", "User"), 
                "User"
            )
            
            Log-Info "yarn bin目录已添加到PATH环境变量。"
        }
        
        Log-Info "✅ yarn已设置为默认包管理器。"
        Log-Info "现在可以使用yarn命令代替npm命令。"
        Log-Info "例如: yarn add [包名] 代替 npm install --save [包名]"
        Log-Info "函数别名已设置: npm → yarn, npx → yarn dlx"
        Log-Info "您需要重新加载PowerShell配置才能生效:"
        Log-Info ". `$PROFILE"
    } catch {
        Log-Error "设置yarn为默认包管理器失败: $_"
    }
}

# 配置Python工具
function Set-PythonTools {
    Log-Info "配置Python工具..."
    
    # 配置pip
    if (Test-ToolInstalled "pip") {
        Log-Info "配置pip..."
        try {
            # 创建pip配置目录和文件
            $pipConfigDir = Join-Path $env:APPDATA "pip"
            New-Item -Path $pipConfigDir -ItemType Directory -Force | Out-Null
            
            $pipConfigFile = Join-Path $pipConfigDir "pip.ini"
            Set-Content -Path $pipConfigFile -Value @"
[global]
cache-dir = $($script:SDK_PATH -replace '\\', '/')/python/python_cache/pip
"@
            Log-Info "已创建pip配置文件: $pipConfigFile"
            
            # 同时尝试使用命令行方式（如果支持）
            try {
                pip config set global.cache-dir "$($script:SDK_PATH -replace '\\', '/')/python/python_cache/pip" 2>$null
            } catch {
                # 忽略错误，因为不是所有pip版本都支持config命令
            }
        } catch {
            Log-Warn "pip配置失败: $_"
        }
    } else {
        Log-Warn "未安装pip，跳过配置。"
    }
    
    # 配置poetry
    if (Test-ToolInstalled "poetry") {
        Log-Info "配置poetry..."
        try {
            poetry config cache-dir (Join-Path $script:SDK_PATH "python\python_cache\poetry")
            Log-Info "poetry配置完成。"
            
            # 验证配置
            Log-Info "poetry cache-dir: $(poetry config cache-dir)"
        } catch {
            Log-Warn "poetry配置失败: $_"
        }
    } else {
        Log-Warn "未安装poetry，跳过配置。"
    }
}

# 配置Java工具
function Set-JavaTools {
    Log-Info "配置Java工具..."
    
    # 配置Maven
    if (Test-ToolInstalled "mvn") {
        Log-Info "配置Maven..."
        try {
            # 创建Maven设置目录
            $m2Dir = Join-Path $env:USERPROFILE ".m2"
            New-Item -Path $m2Dir -ItemType Directory -Force | Out-Null
            
            # 创建settings.xml文件
            $settingsFile = Join-Path $m2Dir "settings.xml"
            Set-Content -Path $settingsFile -Value @"
<settings>
  <localRepository>$($script:SDK_PATH -replace '\\', '/')/maven/repository</localRepository>
</settings>
"@
            Log-Info "Maven配置完成: $settingsFile"
        } catch {
            Log-Warn "Maven配置失败: $_"
        }
    } else {
        Log-Warn "未安装Maven，跳过配置。"
    }
    
    # 配置Gradle
    if (Test-ToolInstalled "gradle") {
        Log-Info "配置Gradle..."
        try {
            # 创建Gradle配置目录
            $gradleDir = Join-Path $env:USERPROFILE ".gradle"
            New-Item -Path $gradleDir -ItemType Directory -Force | Out-Null
            
            # 创建gradle.properties文件
            $gradlePropsFile = Join-Path $gradleDir "gradle.properties"
            Set-Content -Path $gradlePropsFile -Value @"
org.gradle.user.home=$($script:SDK_PATH -replace '\\', '/')/java/java_cache/gradle
"@
            Log-Info "Gradle配置完成: $gradlePropsFile"
        } catch {
            Log-Warn "Gradle配置失败: $_"
        }
    } else {
        Log-Warn "未安装Gradle，跳过配置。"
    }
}

# 配置Ruby工具
function Set-RubyTools {
    Log-Info "配置Ruby工具..."
    
    # 配置Bundler
    if (Test-ToolInstalled "bundle") {
        Log-Info "配置Bundler..."
        try {
            # 尝试多种配置方法，以适应不同版本的bundler
            try { 
                bundle config set path "$($script:SDK_PATH -replace '\\', '/')/ruby/ruby_cache/bundle" 2>$null 
            } catch {}
            
            try { 
                bundle config path "$($script:SDK_PATH -replace '\\', '/')/ruby/ruby_cache/bundle" 2>$null 
            } catch {}
            
            try { 
                bundle config --global path "$($script:SDK_PATH -replace '\\', '/')/ruby/ruby_cache/bundle" 2>$null 
            } catch {}
            
            # 创建配置文件作为备份方法
            $bundleConfigDir = Join-Path $env:USERPROFILE ".bundle"
            New-Item -Path $bundleConfigDir -ItemType Directory -Force | Out-Null
            
            $bundleConfigFile = Join-Path $bundleConfigDir "config"
            Set-Content -Path $bundleConfigFile -Value @"
---
BUNDLE_PATH: "$($script:SDK_PATH -replace '\\', '/')/ruby/ruby_cache/bundle"
"@
            Log-Info "Bundler配置完成。"
        } catch {
            Log-Warn "Bundler配置失败: $_"
        }
    } else {
        Log-Warn "未安装Bundler，跳过配置。"
    }
}

# 配置Rust工具
function Set-RustTools {
    Log-Info "配置Rust工具..."
    
    # 配置Cargo
    if (Test-ToolInstalled "cargo") {
        Log-Info "配置Cargo..."
        try {
            # 创建Cargo配置目录
            $cargoDir = Join-Path $env:USERPROFILE ".cargo"
            New-Item -Path $cargoDir -ItemType Directory -Force | Out-Null
            
            # 创建config.toml文件
            $cargoConfigFile = Join-Path $cargoDir "config.toml"
            Set-Content -Path $cargoConfigFile -Value @"
[build]
target-dir = "$($script:SDK_PATH -replace '\\', '/')/rust/rust_cache/cargo/target"
"@
            Log-Info "Cargo配置完成: $cargoConfigFile"
        } catch {
            Log-Warn "Cargo配置失败: $_"
        }
    } else {
        Log-Warn "未安装Cargo，跳过配置。"
    }
}

# 配置PHP工具
function Set-PHPTools {
    Log-Info "配置PHP工具..."
    
    # 配置Composer
    if (Test-ToolInstalled "composer") {
        Log-Info "配置Composer..."
        try {
            composer config -g cache-dir (Join-Path $script:SDK_PATH "php\php_cache\composer\cache")
            Log-Info "Composer配置完成。"
            
            # 验证配置
            Log-Info "Composer cache-dir: $(composer config -g cache-dir)"
        } catch {
            Log-Warn "Composer配置失败: $_"
        }
    } else {
        Log-Warn "未安装Composer，跳过配置。"
    }
}

# 配置.NET工具
function Set-DotNetTools {
    Log-Info "配置.NET工具..."
    
    # 配置NuGet
    if (Test-ToolInstalled "dotnet") {
        Log-Info "配置NuGet..."
        try {
            # 创建NuGet配置目录
            $nugetDir = Join-Path $env:APPDATA "NuGet"
            New-Item -Path $nugetDir -ItemType Directory -Force | Out-Null
            
            # 创建NuGet.Config文件
            $nugetConfigFile = Join-Path $nugetDir "NuGet.Config"
            Set-Content -Path $nugetConfigFile -Value @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <add key="globalPackagesFolder" value="$($script:SDK_PATH -replace '\\', '/')/dotnet/dotnet_cache/nuget/packages" />
  </config>
</configuration>
"@
            Log-Info "NuGet配置完成: $nugetConfigFile"
        } catch {
            Log-Warn "NuGet配置失败: $_"
        }
    } else {
        Log-Warn "未安装.NET，跳过配置。"
    }
}

# 创建环境变量配置文件（作为备份机制）
function New-EnvFile {
    Log-Info "创建环境变量配置文件: $script:ENV_FILE"
    
    $envContent = @"
# SDK路径环境变量配置 - 备份机制
# 由configure_sdk_with_commands.ps1自动生成于 $(Get-Date)
# 注意：这些环境变量作为备份机制，优先使用工具自身的配置

# 主SDK路径
`$env:SDK_PATH = "$($script:SDK_PATH)"

# Node.js配置
`$env:NODE_CACHE_DIR = "`$env:SDK_PATH\nodejs\node_cache"
`$env:NPM_CONFIG_PREFIX = "`$env:NODE_CACHE_DIR\npm-global"
`$env:NPM_CONFIG_CACHE = "`$env:NODE_CACHE_DIR\npm-cache"
`$env:YARN_CACHE_FOLDER = "`$env:NODE_CACHE_DIR\yarn-cache"
`$env:PNPM_STORE_DIR = "`$env:NODE_CACHE_DIR\pnpm-store"
`$env:PATH = "`$env:NPM_CONFIG_PREFIX\bin;`$env:PATH"

# Python配置
`$env:PYTHON_CACHE_DIR = "`$env:SDK_PATH\python\python_cache"
`$env:PIP_CACHE_DIR = "`$env:PYTHON_CACHE_DIR\pip"
`$env:PIP_DOWNLOAD_CACHE = "`$env:PYTHON_CACHE_DIR\pip-download"
`$env:WORKON_HOME = "`$env:PYTHON_CACHE_DIR\venvs"
`$env:VIRTUALENV_HOME = "`$env:PYTHON_CACHE_DIR\venvs"
`$env:PIPENV_CACHE_DIR = "`$env:PYTHON_CACHE_DIR\pipenv"
`$env:PIPENV_VENV_IN_PROJECT = "0"
`$env:PIPENV_VIRTUALENV = "`$env:PYTHON_CACHE_DIR\pipenv-venvs"
`$env:POETRY_CACHE_DIR = "`$env:PYTHON_CACHE_DIR\poetry"

# Java配置
`$env:JAVA_CACHE_DIR = "`$env:SDK_PATH\java\java_cache"
`$env:GRADLE_USER_HOME = "`$env:JAVA_CACHE_DIR\gradle"

# Maven配置
`$env:M2_HOME = "`$env:SDK_PATH\maven"
`$env:MAVEN_OPTS = "-Dmaven.repo.local=`$env:SDK_PATH\maven\repository"

# Go配置
`$env:GO_CACHE_DIR = "`$env:SDK_PATH\golang\go_cache"
`$env:GOPATH = "`$env:GO_CACHE_DIR"
`$env:GOMODCACHE = "`$env:GO_CACHE_DIR\pkg\mod"
`$env:GOCACHE = "`$env:GO_CACHE_DIR\go-build"
`$env:PATH = "`$env:GOPATH\bin;`$env:PATH"

# Ruby配置
`$env:RUBY_CACHE_DIR = "`$env:SDK_PATH\ruby\ruby_cache"
`$env:GEM_HOME = "`$env:RUBY_CACHE_DIR\gems"
`$env:GEM_PATH = "`$env:RUBY_CACHE_DIR\gems"
`$env:BUNDLE_USER_HOME = "`$env:RUBY_CACHE_DIR\bundle"
`$env:BUNDLE_PATH = "`$env:RUBY_CACHE_DIR\bundle"
`$env:PATH = "`$env:GEM_HOME\bin;`$env:PATH"

# Rust配置
`$env:RUST_CACHE_DIR = "`$env:SDK_PATH\rust\rust_cache"
`$env:CARGO_HOME = "`$env:RUST_CACHE_DIR\cargo"
`$env:RUSTUP_HOME = "`$env:RUST_CACHE_DIR\rustup"
`$env:PATH = "`$env:CARGO_HOME\bin;`$env:PATH"

# .NET配置
`$env:DOTNET_CACHE_DIR = "`$env:SDK_PATH\dotnet\dotnet_cache"
`$env:NUGET_PACKAGES = "`$env:DOTNET_CACHE_DIR\nuget\packages"
`$env:DOTNET_TOOLS_DIR = "`$env:DOTNET_CACHE_DIR\tools"
`$env:PATH = "`$env:DOTNET_TOOLS_DIR;`$env:PATH"

# PHP配置
`$env:PHP_CACHE_DIR = "`$env:SDK_PATH\php\php_cache"
`$env:COMPOSER_HOME = "`$env:PHP_CACHE_DIR\composer"
`$env:COMPOSER_CACHE_DIR = "`$env:PHP_CACHE_DIR\composer\cache"
`$env:PATH = "`$env:COMPOSER_HOME\vendor\bin;`$env:PATH"

# Dart & Flutter配置
`$env:FLUTTER_CACHE_DIR = "`$env:SDK_PATH\flutter\flutter_cache"
`$env:PUB_CACHE = "`$env:FLUTTER_CACHE_DIR\pub-cache"
`$env:PATH = "`$env:PUB_CACHE\bin;`$env:PATH"

# 输出确认信息
Write-Host "SDK环境变量已加载，路径: `$env:SDK_PATH"
"@

    Set-Content -Path $script:ENV_FILE -Value $envContent
    Log-Info "环境变量配置文件创建完成: $script:ENV_FILE"
}

# 添加环境变量到PowerShell配置文件
function Add-ToShellConfig {
    [CmdletBinding()]
    param()
    
    Log-Info "添加环境变量到PowerShell配置..."
    
    # 检查环境变量文件是否存在
    if (-not (Test-Path $ENV_FILE)) {
        Log-Error "环境变量文件不存在: $ENV_FILE"
        return
    }
    
    # 检查PowerShell配置文件路径
    $configsUpdated = $false
    
    # 处理当前用户的PowerShell配置
    $currentUserProfile = $PROFILE.CurrentUserAllHosts
    
    # 更新当前用户配置
    if (-not (Test-Path $currentUserProfile)) {
        # 创建配置文件目录（如果不存在）
        $profileDir = Split-Path -Parent $currentUserProfile
        if (-not (Test-Path $profileDir)) {
            New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
        }
        
        # 创建配置文件
        New-Item -Path $currentUserProfile -ItemType File -Force | Out-Null
        Log-Info "已创建PowerShell配置文件: $currentUserProfile"
    }
    
    # 检查是否已添加到配置文件
    $currentContent = Get-Content -Path $currentUserProfile -Raw -ErrorAction SilentlyContinue
    if (-not ($currentContent -match [regex]::Escape(". `"$ENV_FILE`""))) {
        Add-Content -Path $currentUserProfile -Value @"

# SDK路径环境变量配置（备份机制）
. "$ENV_FILE"
"@
        Log-Info "已添加配置到用户配置文件: $currentUserProfile"
        $configsUpdated = $true
    } else {
        Log-Info "配置已存在于: $currentUserProfile"
    }
    
    # 同时设置系统环境变量（更可靠的方法）
    try {
        Log-Info "设置系统环境变量..."
        # 设置SDK_PATH作为系统环境变量
        [Environment]::SetEnvironmentVariable("SDK_PATH", $SDK_PATH, "User")
        Log-Info "已设置SDK_PATH环境变量: $SDK_PATH"
        
        # 设置常用的缓存目录环境变量
        [Environment]::SetEnvironmentVariable("NODE_CACHE_DIR", "$SDK_PATH\nodejs\node_cache", "User")
        [Environment]::SetEnvironmentVariable("PYTHON_CACHE_DIR", "$SDK_PATH\python\python_cache", "User")
        [Environment]::SetEnvironmentVariable("JAVA_CACHE_DIR", "$SDK_PATH\java\java_cache", "User")
        
        # 更新PATH变量（添加常用工具的bin目录）
        $pathAdditions = @(
            "$SDK_PATH\nodejs\node_cache\npm-global",
            "$SDK_PATH\golang\go_cache\bin",
            "$SDK_PATH\rust\rust_cache\cargo\bin"
        )
        
        # 获取当前PATH
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        $newPaths = @()
        
        # 添加新路径（如果不存在）
        foreach ($path in $pathAdditions) {
            if (-not $currentPath.Contains($path)) {
                $newPaths += $path
            }
        }
        
        # 如果有新路径要添加
        if ($newPaths.Count -gt 0) {
            $updatedPath = ($newPaths -join ";") + ";" + $currentPath
            [Environment]::SetEnvironmentVariable("PATH", $updatedPath, "User")
            Log-Info "已更新PATH环境变量，添加了SDK工具路径"
        }
        
        Log-Info "系统环境变量设置完成"
    } catch {
        Log-Error "设置系统环境变量失败: $_"
    }
    
    # 提示用户重新加载配置
    if ($configsUpdated) {
        Log-Info "请重新加载PowerShell配置以使环境变量立即生效:"
        Log-Info ". $currentUserProfile"
    }
    
    Log-Info "要使环境变量在所有应用程序中生效，您可能需要注销并重新登录。"
    
    # 创建一个简单的激活脚本，但不提示用户
    $activateScript = Join-Path $SDK_PATH "Activate.ps1"
    Set-Content -Path $activateScript -Value @"
# SDK环境激活脚本
# 使用方法: . $activateScript
# 由configure_sdk_with_commands.ps1自动生成于 $(Get-Date)

# 加载环境变量
. "$ENV_FILE"

Write-Host "SDK环境已加载，路径: $SDK_PATH" -ForegroundColor Green
"@
}

# 验证配置
function Test-Config {
    Log-Info "验证配置..."
    
    # 验证npm配置
    if (Test-ToolInstalled "npm") {
        $npmPrefix = npm config get prefix
        $npmCache = npm config get cache
        
        if ($npmPrefix -eq (Join-Path $script:SDK_PATH "nodejs\node_cache\npm-global")) {
            Log-Info "✅ npm prefix 配置正确: $npmPrefix"
        } else {
            Log-Warn "❌ npm prefix 配置不正确: $npmPrefix"
        }
        
        if ($npmCache -eq (Join-Path $script:SDK_PATH "nodejs\node_cache\npm-cache")) {
            Log-Info "✅ npm cache 配置正确: $npmCache"
        } else {
            Log-Warn "❌ npm cache 配置不正确: $npmCache"
        }
    }
    
    # 验证yarn配置
    if (Test-ToolInstalled "yarn") {
        $yarnCache = yarn config get cache-folder
        
        if ($yarnCache -eq (Join-Path $script:SDK_PATH "nodejs\node_cache\yarn-cache")) {
            Log-Info "✅ yarn cache-folder 配置正确: $yarnCache"
        } else {
            Log-Warn "❌ yarn cache-folder 配置不正确: $yarnCache"
        }
    }
    
    # 验证pnpm配置
    if (Test-ToolInstalled "pnpm") {
        $pnpmStore = pnpm config get store-dir
        
        if ($pnpmStore -eq (Join-Path $script:SDK_PATH "nodejs\node_cache\pnpm-store")) {
            Log-Info "✅ pnpm store-dir 配置正确: $pnpmStore"
        } else {
            Log-Warn "❌ pnpm store-dir 配置不正确: $pnpmStore"
        }
    }
    
    # 验证pip配置
    if (Test-ToolInstalled "pip") {
        # 检查配置文件
        $pipConfigFile = Join-Path $env:APPDATA "pip\pip.ini"
        if (Test-Path $pipConfigFile) {
            Log-Info "✅ pip cache-dir 已配置: $($script:SDK_PATH)/python/python_cache/pip (通过配置文件)"
        }
        
        # 尝试使用命令行检查（如果支持）
        try {
            $pipCache = pip config list 2>$null | Select-String -Pattern "cache-dir"
            if ($pipCache) {
                Log-Info "pip cache-dir (通过命令): $pipCache"
            }
        } catch {
            # 忽略错误
        }
    }
    
    # 验证Maven配置
    if (Test-ToolInstalled "mvn") {
        # 检查settings.xml文件
        $m2SettingsFile = Join-Path $env:USERPROFILE ".m2\settings.xml"
        if (Test-Path $m2SettingsFile) {
            $settingsContent = Get-Content -Path $m2SettingsFile -Raw
            if ($settingsContent -match "<localRepository>.*maven/repository</localRepository>") {
                Log-Info "✅ Maven localRepository 配置已存在"
            } else {
                Log-Warn "❌ Maven localRepository 配置不正确"
            }
        } else {
            Log-Warn "❌ Maven settings.xml 文件不存在"
        }
    }
    
    # 验证bundle配置
    if (Test-ToolInstalled "bundle") {
        # 检查配置文件
        $bundleConfigFile = Join-Path $env:USERPROFILE ".bundle\config"
        if (Test-Path $bundleConfigFile) {
            Log-Info "✅ bundle path 已配置: $($script:SDK_PATH)/ruby/ruby_cache/bundle (通过配置文件)"
        }
        
        # 尝试使用命令行检查（如果支持）
        try {
            $bundlePath = $null
            try { $bundlePath = bundle config get path 2>$null } catch {}
            if (-not $bundlePath) { try { $bundlePath = bundle config path 2>$null } catch {} }
            
            if ($bundlePath) {
                Log-Info "bundle path (通过命令): $bundlePath"
            }
        } catch {
            # 忽略错误
        }
    }
    
    # 验证composer配置
    if (Test-ToolInstalled "composer") {
        $composerCache = composer config -g cache-dir
        
        if ($composerCache -eq (Join-Path $script:SDK_PATH "php\php_cache\composer\cache")) {
            Log-Info "✅ composer cache-dir 配置正确: $composerCache"
        } else {
            Log-Warn "❌ composer cache-dir 配置不正确: $composerCache"
        }
    }
    
    Log-Info "配置验证完成。"
}

# 显示帮助信息
function Show-Help {
    Write-Host "用法: .\configure_sdk_with_commands.ps1 [SDK路径]"
    Write-Host ""
    Write-Host "使用工具自带命令配置编程语言SDK的缓存、依赖和下载位置。"
    Write-Host ""
    Write-Host "参数:"
    Write-Host "  [SDK路径]  SDK集中存储的路径，默认为 C:\AllSDKs"
    Write-Host ""
    Write-Host "示例:"
    Write-Host "  .\configure_sdk_with_commands.ps1 C:\AllSDKs"
    Write-Host "  .\configure_sdk_with_commands.ps1 D:\Development\SDKs"
}

# 主函数
function Main {
    # 选择语言
    Select-Language
    
    # 显示欢迎信息
    Log-Info $(Get-Message -Key "welcome")
    Log-Info $(Get-Message -Key "sdk_path" -Args $script:SDK_PATH)
    
    # 检查是否只需要设置yarn为默认包管理器
    if ($script:YARN_DEFAULT_ONLY -eq $true) {
        Set-YarnAsDefaultPackageManager
        return
    }
    
    # 创建目录结构
    New-Directories
    
    # 配置各种工具
    Set-PythonTools
    Set-JavaTools
    Set-RubyTools
    Set-RustTools
    Set-PHPTools
    Set-DotNetTools
    
    # 配置Node.js工具，但跳过yarn默认包管理器设置
    Log-Info $(Get-Message -Key "config_nodejs")
    
    # 配置npm
    if (Test-ToolInstalled "npm") {
        Log-Info $(Get-Message -Key "config_npm")
        try {
            npm config set prefix "$script:SDK_PATH\nodejs\node_cache\npm-global"
            npm config set cache "$script:SDK_PATH\nodejs\node_cache\npm-cache"
            Log-Info $(Get-Message -Key "npm_configured")
            
            # 验证配置
            Log-Info "npm prefix: $(npm config get prefix)"
            Log-Info "npm cache: $(npm config get cache)"
        } catch {
            Log-Warn $(Get-Message -Key "npm_failed")
        }
    } else {
        Log-Warn $(Get-Message -Key "npm_not_installed")
    }
    
    # 配置yarn
    if (Test-ToolInstalled "yarn") {
        Log-Info $(Get-Message -Key "config_yarn")
        try {
            # 创建yarn全局目录
            New-Item -Path "$script:SDK_PATH\nodejs\node_cache\yarn-global" -ItemType Directory -Force | Out-Null
            
            # 设置yarn缓存和全局目录
            yarn config set cache-folder "$script:SDK_PATH\nodejs\node_cache\yarn-cache"
            yarn config set global-folder "$script:SDK_PATH\nodejs\node_cache\yarn-global"
            Log-Info $(Get-Message -Key "yarn_configured")
            
            # 验证配置
            Log-Info "yarn cache-folder: $(yarn config get cache-folder)"
            Log-Info "yarn global-folder: $(yarn config get global-folder)"
        } catch {
            Log-Warn $(Get-Message -Key "yarn_failed")
        }
    } else {
        Log-Warn $(Get-Message -Key "yarn_not_installed")
    }
    
    # 配置pnpm
    if (Test-ToolInstalled "pnpm") {
        Log-Info $(Get-Message -Key "config_pnpm")
        try {
            pnpm config set store-dir "$script:SDK_PATH\nodejs\node_cache\pnpm-store"
            Log-Info $(Get-Message -Key "pnpm_configured")
            
            # 验证配置
            Log-Info "pnpm store-dir: $(pnpm config get store-dir)"
        } catch {
            Log-Warn $(Get-Message -Key "pnpm_failed")
        }
    } else {
        Log-Warn $(Get-Message -Key "pnpm_not_installed")
    }
    
    # 只询问是否将yarn设置为默认包管理器
    $setYarnDefault = Read-Host $(Get-Message -Key "set_yarn_default")
    if ($setYarnDefault -eq "y" -or $setYarnDefault -eq "Y") {
        Set-YarnAsDefaultPackageManager
    }
    
    # 创建环境变量配置文件（作为备份机制）
    New-EnvFile
    
    # 添加到PowerShell配置（作为备份机制）
    Add-ToShellConfig
    
    # 验证配置
    Test-Config
    
    Log-Info $(Get-Message -Key "config_complete")
    Log-Info $(Get-Message -Key "config_complete_detail" -Args $script:SDK_PATH)
    Log-Info $(Get-Message -Key "env_vars_set")
    Log-Info ""
    Log-Info $(Get-Message -Key "reload_shell")
    Log-Info $(Get-Message -Key "reload_cmd")
}

# 检查是否请求帮助
if ($args -contains "-h" -or $args -contains "--help") {
    Show-Help
    exit 0
}

# 执行主函数
Main 