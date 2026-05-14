param(
    [switch]$adminPhase
)

@"
-------------------------------------------------------------------------
StartUpWindows
仓库：https://github.com/Bluore/StartUpWindows
给Windows开荒用的一键化配置脚本
-------------------------------------------------------------------------
功能：
1. 安装并配置常用开发环境 WSL Python Golang Neovim Lua Nginx Git SSH...
2. Windows Terminal 终端美化
3. 激活Windows
-------------------------------------------------------------------------
3s 后自动进行...期间请输入y来确认操作
"@

ping 127.0.0.1 -n 4 > $null

function Is-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function HasCmd {
    param(
        [string]$Name
    )

    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not $adminPhase -and -not (Is-Admin)) {
    # 非管理员
    if (-not (HasCmd "scoop")) {
        echo "-> 安装scoop"
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    }
    
    # 提升权限运行
    echo "-> 即将提升到管理员权限运行 (1s后)"
    ping 127.0.0.1 -n 2 > $null
    Start-Process pwsh -Verb RunAs -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy Bypass",
        "-File `"$PSCommandPath`"",
        "-adminPhase"
    )

    ping 127.0.0.1 -n 4 > $null
    exit
}

if (-not (HasCmd "scoop")){
    echo "-> 请先通过非管理员权限运行!!!"
    ping 127.0.0.1 -n 11 > $null

    exit
}

$isSetupBaseDevEnv = Read-Host "? 是否安装基础开发环境? (y/n)"
if ($isSetupBaseDevEnv -eq "y"){
    @"
-> 安装基础开发环境
nodejs gcc mingw vim neovim python uv go lua yazi btop docker
"@
    ping 127.0.0.1 -n 2 > $null

    scoop install nodejs gcc mingw vim neovim python uv go lua yazi btop docker
    npm install -g pnpm
}

if (-not (HasCmd "git")){
    $isSetupGit = Read-Host "? 是否安装配置git? (y/n)"
    if ($isSetupGit -eq "y") {
        scoop install git
        echo "-> 配置git"
        $gitName = Read-Host "Git Name(Git昵称)"
        $gitEmail = Read-Host "Git Email(Git邮箱)"
        git config --global user.name $gitName
        git config --global user.email $gitEmail
    }
}else{
    echo "-> 已安装git，跳过此步骤"
}

$isGenerateSSHKey = Read-Host "? 是否生成SSH Key? (y/n)"
if ($isGenerateSSHKey -eq "y"){
    if ($gitEmail -eq ""){
        $gitEmail = Read-Host "Your Email 你的邮箱"
    }
    ssh-keygen -t ed25519 -C $gitEmail
    echo "你的SSH公钥:"
    Get-Content $HOME"/.ssh/id_ed25519.pub"
}

$isCheangeTerminal = Read-Host "? 是否美化终端？此操作会覆盖原有配置 (y/n)"
if ($isCheangeTerminal -eq "y"){
    echo "-> 美化终端"
    winget install JanDeDobbeleer.OhMyPosh --source winget
    oh-my-posh font install CascadiaCode
    New-Item -Path $PROFILE -Type File -Force
    Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh | Invoke-Expression"
    echo "-> 正在修改脚本执行策略为 RemoteSigned "
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine 
}

$isSetupWSL = Read-Host "? 是否安装WSL? (y/n)"
if ($isSetupWSL -eq "y"){
    echo "-> 安装WSL"
    wsl --install Ubuntu
}

$isActiveWindows = Read-Host "? 是否激活Windows? (y/n)"
if ($isActiveWindows -eq "y"){
    irm https://get.activated.win | iex
}

if ($isCheangeTerminal -eq "y") {
    @"
请把以下内容添加到terminal的配置文件，详见：https://ohmyposh.dev/docs/installation/fonts#configuration
-------------------------------------------------------------------------
{
    "profiles":
    {
        "defaults":
        {
            "font":
            {
                "face": "CaskaydiaCove Nerd Font"
            }
        }
    }
}
-------------------------------------------------------------------------
"@
}

@"
电脑开荒推荐：
【解压软件】    PeaZip: https://github.com/peazip/PeaZip/
【截图软件】    Pixpin: https://pixpin.cn/
【视频播放器】  Potplayer:  https://potplayer.tv/
【文本编辑器】  VSCode: https://code.visualstudio.com/
【网络代理】    V2ray:  https://github.com/2dust/v2rayN
【资源管理器】  OneCommander:   https://onecommander.com/
"@

ping 127.0.0.1 -n 11 > $null

echo "程序执行完毕，请手动退出..."

ping 127.0.0.1 -n 999999 > $null