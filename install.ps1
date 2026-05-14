
$Apps = @(
    "Microsoft.VisualStudioCode",
    "Giorgiotani.Peazip",
    "PixPin.PixPin"
    "Daum.PotPlayer"
    "2dust.v2rayN"
    "xishang0128.Sparkle"
    "Microsoft.PowerToys"
    "GtxFury.FlyClash"
    "Git.Git",
    "GitHub.GitHubDesktop",
    "JetBrains.PyCharm.Community",
    "JetBrains.GoLand",
    "Neovim.Neovim",
    "Python.Python.3.13",
    "OpenJS.NodeJS",
    "GoLang.Go",
    "Oracle.JDK.21",
    "Rustlang.Rustup",
    "Docker.DockerDesktop",
    "PostgreSQL.PostgreSQL",
    "MySQL.MySQLServer",
    "Microsoft.SQLServerManagementStudio",
    "7zip.7zip",
    "Mozilla.Firefox",
    "Google.Chrome",
    "Microsoft.PowerShell",
    "Microsoft.WindowsTerminal",
    "OBSProject.OBSStudio"
)

function install {
    param (
        [string]$Name
    )
    winget install $Name
}

function askInstall {
    param (
        [string]$Name
    )
    
    @"
-------------------------------------------------------------------------
安装程序： $Name
"@
    winget show $Name
@"
输入y后下载
-------------------------------------------------------------------------
"@
    $isInstall = Read-Host "是否下载并安装 $Name ? (Y/n)"
    if ($isInstall -eq "y") {
        install $Name
        ping 127.0.0.1 -n 4 > $null
    } else {
        echo "取消安装 $Name "
        ping 127.0.0.1 -n 2 > $null
    }
}


while ($true) {
    clear
    $index = 0 
    @"
-------------------------------------------------------------------------
"@
    foreach ($app in $Apps) {
        echo "        ($($index+1)) $($Apps[$index])"

        $index++
    }
    
    @"
        (0).退出程序
-------------------------------------------------------------------------
"@
    $in = Read-Host "请输入你要安装程序的编号? (Number)"
    $downIndex = [int]$in -1
    if ($downIndex -lt 0){
        exit
    }
    if (($downIndex -ge 0) -and ($downIndex -le $Apps.Length)){
        clear
        askInstall $Apps[$downIndex]
    }else{
        clear
        echo "输入不合法"
        ping 127.0.0.1 -n 2 > $null
    }
}