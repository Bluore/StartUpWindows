echo "-> 安装scoop"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

echo "-> 安装基础开发环境"
scoop install nodejs gcc mingw vim neovim python uv go lua yazi btop docker
npm install -g pnpm

git -v > $null
if (-not $?){
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
    "oh-my-posh init pwsh | Invoke-Expression" > $PROFILE
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
软件推荐列表：
【解压软件】    PeaZip: https://github.com/peazip/PeaZip/
【截图软件】    Pixpin: https://pixpin.cn/
【视频播放器】  Potplayer:  https://potplayer.tv/
【文本编辑器】  VSCode: https://code.visualstudio.com/
【网络代理】    V2ray:  https://github.com/2dust/v2rayN
【资源管理器】  OneCommander:   https://onecommander.com/
"@