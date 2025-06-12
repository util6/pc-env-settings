# 清理旧的SDK依赖缓存
# 作者：Claude
# 创建日期：$(Get-Date -Format "yyyy-MM-dd")

# 设置颜色输出函数
function Write-ColorOutput {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$true)]
        [string]$ForegroundColor
    )
    
    $originalColor = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $originalColor
}

# 设置日志函数
function Log-Info {
    param ([string]$Message)
    Write-ColorOutput "[信息] $Message" "Green"
}

function Log-Warn {
    param ([string]$Message)
    Write-ColorOutput "[警告] $Message" "Yellow"
}

function Log-Error {
    param ([string]$Message)
    Write-ColorOutput "[错误] $Message" "Red"
}

# 清理前确认
function Confirm-Cleanup {
    $confirm = Read-Host "是否确认清理旧的SDK缓存? [y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Log-Info "操作已取消。"
        exit 0
    }
}

# 清理Node.js缓存
function Cleanup-NodeJS {
    Log-Info "清理Node.js缓存..."
    
    # 清理npm缓存
    $npmPath = Join-Path $env:USERPROFILE ".npm"
    if (Test-Path $npmPath) {
        Log-Warn "发现旧的npm缓存: $npmPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $npmPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $npmPath"
        } else {
            Log-Info "保留 $npmPath"
        }
    } else {
        Log-Info "未发现旧的npm缓存。"
    }
    
    # 清理yarn缓存
    $yarnCachePath = Join-Path $env:USERPROFILE ".yarn-cache"
    if (Test-Path $yarnCachePath) {
        Log-Warn "发现旧的yarn缓存: $yarnCachePath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $yarnCachePath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $yarnCachePath"
        } else {
            Log-Info "保留 $yarnCachePath"
        }
    }
    
    $yarnCachePath2 = Join-Path $env:LOCALAPPDATA "Yarn\Cache"
    if (Test-Path $yarnCachePath2) {
        Log-Warn "发现旧的yarn缓存: $yarnCachePath2"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $yarnCachePath2 -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $yarnCachePath2"
        } else {
            Log-Info "保留 $yarnCachePath2"
        }
    }
}

# 清理Python缓存
function Cleanup-Python {
    Log-Info "清理Python缓存..."
    
    # 清理pip缓存
    $pipCachePath = Join-Path $env:LOCALAPPDATA "pip\Cache"
    if (Test-Path $pipCachePath) {
        Log-Warn "发现旧的pip缓存: $pipCachePath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $pipCachePath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $pipCachePath"
        } else {
            Log-Info "保留 $pipCachePath"
        }
    } else {
        Log-Info "未发现旧的pip缓存。"
    }
}

# 清理Maven缓存
function Cleanup-Maven {
    Log-Info "清理Maven缓存..."
    
    # 检查Maven仓库
    $mavenRepoPath = Join-Path $env:USERPROFILE ".m2\repository"
    if (Test-Path $mavenRepoPath) {
        Log-Warn "发现旧的Maven仓库: $mavenRepoPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $mavenRepoPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $mavenRepoPath"
        } else {
            Log-Info "保留 $mavenRepoPath"
        }
    } else {
        Log-Info "未发现旧的Maven仓库。"
    }
}

# 清理Gradle缓存
function Cleanup-Gradle {
    Log-Info "清理Gradle缓存..."
    
    $gradlePath = Join-Path $env:USERPROFILE ".gradle"
    if (Test-Path $gradlePath) {
        Log-Warn "发现旧的Gradle缓存: $gradlePath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $gradlePath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $gradlePath"
        } else {
            Log-Info "保留 $gradlePath"
        }
    } else {
        Log-Info "未发现旧的Gradle缓存。"
    }
}

# 清理Go缓存
function Cleanup-Go {
    Log-Info "清理Go缓存..."
    
    $goPath = Join-Path $env:USERPROFILE "go"
    if (Test-Path $goPath) {
        Log-Warn "发现旧的Go工作区: $goPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $goPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $goPath"
        } else {
            Log-Info "保留 $goPath"
        }
    } else {
        Log-Info "未发现旧的Go工作区。"
    }
    
    $goBuildPath = Join-Path $env:LOCALAPPDATA "go-build"
    if (Test-Path $goBuildPath) {
        Log-Warn "发现旧的Go构建缓存: $goBuildPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $goBuildPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $goBuildPath"
        } else {
            Log-Info "保留 $goBuildPath"
        }
    } else {
        Log-Info "未发现旧的Go构建缓存。"
    }
}

# 清理Rust缓存
function Cleanup-Rust {
    Log-Info "清理Rust缓存..."
    
    $cargoPath = Join-Path $env:USERPROFILE ".cargo"
    if (Test-Path $cargoPath) {
        Log-Warn "发现旧的Cargo缓存: $cargoPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $cargoPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $cargoPath"
        } else {
            Log-Info "保留 $cargoPath"
        }
    } else {
        Log-Info "未发现旧的Cargo缓存。"
    }
    
    $rustupPath = Join-Path $env:USERPROFILE ".rustup"
    if (Test-Path $rustupPath) {
        Log-Warn "发现旧的Rustup缓存: $rustupPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $rustupPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $rustupPath"
        } else {
            Log-Info "保留 $rustupPath"
        }
    } else {
        Log-Info "未发现旧的Rustup缓存。"
    }
}

# 清理Composer缓存
function Cleanup-Composer {
    Log-Info "清理Composer缓存..."
    
    $composerPath = Join-Path $env:APPDATA "Composer"
    if (Test-Path $composerPath) {
        Log-Warn "发现旧的Composer缓存: $composerPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $composerPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $composerPath"
        } else {
            Log-Info "保留 $composerPath"
        }
    } else {
        Log-Info "未发现旧的Composer缓存。"
    }
}

# 清理.NET缓存
function Cleanup-DotNet {
    Log-Info "清理.NET缓存..."
    
    $nugetPath = Join-Path $env:USERPROFILE ".nuget"
    if (Test-Path $nugetPath) {
        Log-Warn "发现旧的NuGet缓存: $nugetPath"
        $confirm = Read-Host "是否清理? [y/N]"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Remove-Item -Path $nugetPath -Recurse -Force -ErrorAction SilentlyContinue
            Log-Info "已清理 $nugetPath"
        } else {
            Log-Info "保留 $nugetPath"
        }
    } else {
        Log-Info "未发现旧的NuGet缓存。"
    }
}

# 主函数
function Main {
    Log-Info "===== 旧SDK缓存清理工具 ====="
    Log-Info "此工具将清理旧的SDK依赖缓存，这些缓存现在已被移动到新位置。"
    Log-Warn "清理前请确保已经运行了configure_sdk_with_commands.ps1脚本。"
    
    Confirm-Cleanup
    
    Cleanup-NodeJS
    Cleanup-Python
    Cleanup-Maven
    Cleanup-Gradle
    Cleanup-Go
    Cleanup-Rust
    Cleanup-Composer
    Cleanup-DotNet
    
    Log-Info "===== 清理完成 ====="
    Log-Info "所有旧的SDK缓存已经处理完毕。"
    Log-Info "新的缓存位置在您指定的SDK路径中。"
}

# 执行主函数
Main 