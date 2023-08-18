#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

RMTEMP() {
    rm -rf /etc/systemd/system/multi-user.target.wants/FullTclash.service /etc/systemd/system/FullTclash.service
    rm -rf /usr/local/FullTclash
    rm -rf /usr/bin/FTC
}


ENV_Install() {
    echo -e "${yellow}正在进行环境安装，如遇到需要回复内容时，请直接回车。${plain}"

    #Debian
    apt update
    apt upgrade -y
    apt install python3 python3-pip libffi-dev libssl-dev curl wget git -y
    
    #Cent
    yum update
    yum -y install epel-release
    yum -y install python3-pip curl wget git

    type python3

    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!Python环境尚未正确安装好，请检查是否已安装python3.9+如不能自行解决，请截图提问。!!!"
    exit 1
    fi

    type pip3

    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!Python的Pip环境尚未正确安装好，请检查是否已安装python3.9+以及Pip。如不能自行解决，请截图提问。!!!"
    exit 1
    fi

    echo -e "${yellow}环境已安装完成，如有报错请截图寻求帮助${plain}"
}

CHECK_PYTHON_VERSION(){
    PY_VERSION=`python3 -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1}'`
    PY_VERSION_2=`python3 -V 2>&1|awk '{print $2}'|awk -F '.' '{print $2}'`

    if [  $PY_VERSION == 3 ] && [ $PY_VERSION_2 -ge 9 ]
    then
        echo -e "$green你的Python版本是： $PY_VERSION.$PY_VERSION_2，符合安装标准！$plain"
    else
        echo -e "$redPython版本错误！请检查是否已安装Python3.9+！$plain"
        exit 1
    fi
}

GIT_Install() {
    cd /usr/local
    rm -rf FullTclash
    echo -e "$yellow"
    read -rp "请选择分支(dev/master/backend,默认master):" branch
    echo -e "$plain"
    if [ ! -n "$branch" ]; then
        git clone https://ghproxy.com/https://github.com/AirportR/FullTclash.git
    else
        git clone -b $branch https://ghproxy.com/https://github.com/AirportR/FullTclash.git
    fi
    
    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'git clone'时发生了这是一个错误，请检查您是否安装了git以及git版本是否正确。如不能自行解决，请截图提问。!!!$plain"
    exit 1
    fi
    
    cd ${cur_dir}
}

Install() {
    cd /usr/local/FullTclash/resources
    echo -e "${yellow}接下来是编辑配置文件，编辑错误可能会导致无法启动，甚至崩溃，请确保您的主机已经安装好环境！$plain"
    #curl https://ghproxy.com/https://raw.githubusercontent.com/GenshinMinecraft/FullTclash-Shell-Script/main/config.yaml -O /usr/local/FullTclash/resources/config.yaml
    wget https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/config.yaml -O /usr/local/FullTclash/resources/config.yaml
    ADMIN=0
    APIID=0
    APIHASH=0
    TOKEN=0
    PROXY=0
    PROXY_TYPE=0

    echo -e "$yellow"
    read -p "请输入TeleGram Api ID:" APIID
    read -p "请输入TeleGram Api HASH:" APIHASH
    read -p "请输入FullTclash 机器人管理员 TeleGram ID:" ADMIN
    read -p "请输入TeleGram 机器人 TOKEN:" TOKEN
    read -p "请输入Socks5代理（仅仅是与Telegram服务器通讯，如服务器不在中国则请回车跳过）:" PROXY
    echo -e "$plain"

    #sed 's/被替换的内容/要替换成的内容/g' file

    sed -i "s/<ADMIN>/${ADMIN}/g" /usr/local/FullTclash/resources/config.yaml
    sed -i "s/<APIID>/${APIID}/g" /usr/local/FullTclash/resources/config.yaml
    sed -i "s/<APIHASH>/${APIHASH}/g" /usr/local/FullTclash/resources/config.yaml
    sed -i "s/<TOKEN>/${TOKEN}/g" /usr/local/FullTclash/resources/config.yaml
    sed -i "s/<PROXY>/${PROXY}/g" /usr/local/FullTclash/resources/config.yaml

    cat /usr/local/FullTclash/resources/config.yaml
    echo -e "\n"
    echo -e "${red}"
    cat /usr/local/FullTclash/resources/config.yaml
    echo -e "${plain} 这是您的配置文件，这是由最简配置文件生成的，如果需要更多自定义功能，请浏览 $yellow https://github.com/AirportR/FullTclash/blob/master/resources/config.yaml.example $plain"
    echo -e "$plain 配置文件路径：$yellow /usr/local/FullTclash/resources/config.yaml $plain"

    echo -e "$yellow 正在安装PIP包环境，请稍等...$red"
    echo -e "$yellow 注：此处特别容易产生报错，遇到问题请截图询问。$plain"

    cd /usr/local/FullTclash/
    pip3 install -r /usr/local/FullTclash/requirements.txt

    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'pip3 install -r /usr/local/FullTclash/requirements.txt'时发生了这是一个错误，请检查您的python版本和pip版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi
}

Edit_Systemd() {
    rm -rf /etc/systemd/system/multi-user.target.wants/FullTclash.service /etc/systemd/system/FullTclash.service
    wget -O /etc/systemd/system/FullTclash.service 'https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/FullTclash.service'
    echo -e "$green已完成Systemd守护进程设置。$plain"
}

Start() {
    systemctl daemon-reload
    systemctl start FullTclash.service
    echo -e "$green成功启动FullTclash！$plain"

    wget -O /usr/bin/FTC "https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/FTC.sh"
    chmod +x /usr/bin/FTC
    echo -e "$green快捷脚本已安装完毕，输入$yellow FTC $green即可快捷管理FullTclash！$plain"
    
}



RMTEMP
ENV_Install
CHECK_PYTHON_VERSION
GIT_Install
Install
Edit_Systemd
Start
