#/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "请使用root用户运行此脚本" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
    echo -e "本程序暂不支持CentOS"
    exit 1
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    echo -e "本程序暂不支持CentOS"
    exit 1
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    echo -e "本程序暂不支持CentOS"
    exit 1
else
    echo -e "${red}未检测到系统版本，自动退出！" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
    echo -e "暂不支持arm64架构！"
    exit 1
elif [[ $arch == "s390x" ]]; then
    arch="s390x"
    echo -e "暂不支持s390x架构！"
    exit 1
else
    echo -e "暂不支持您的架构！"
    exit 1
fi

echo "架构: ${arch}"

if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ]; then
    echo "本软件不支持 32 位系统(x86)，请使用 64 位系统(x86_64)，如果检测有误，请联系作者"
    exit -1
fi

ENV_Install() {
    echo -e "${yellow}正在进行环境安装，如遇到需要回复内容时，请直接回车。${plain}"

    apt update
    apt upgrade -y
    apt install python3 python3-pip python3-dev libffi-dev libssl-dev curl wget git -y
    echo -e "${yellow}环境已安装完成，如有报错请截图或报错寻求帮助${plain}"
}

GIT_Install() {
    cd /usr/local
    rm -rf FullTclash
    #git clone https://ghproxy.com/https://github.com/AirportR/FullTclash.git
    git clone https://github.com/AirportR/FullTclash.git
    cd ${cur_dir}
}

Install() {
    cd /usr/local/FullTclash/resources
    echo -e "${yellow}接下来是编辑配置文件，编辑错误可能会导致无法启动，甚至崩溃，请确保您的主机已经安装好环境！$plain"
    #curl https://ghproxy.com/https://raw.githubusercontent.com/GenshinMinecraft/FullTclash-Shell-Script/main/config.yaml -O /usr/local/FullTclash/resources/config.yml
    wget https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/config.yaml -O /usr/local/FullTclash/resources/config.yml
    ADMIN=0
    APIID=0
    APIHASH=0
    TOKEN=0
    PROXY=0
    PROXY_TYPE=0


    read -p "请输入TeleGram Api ID:" APIID
    read -p "请输入TeleGram Api HASH:" APIHASH
    read -p "请输入FullTclash 机器人管理员 TeleGram ID:" ADMIN
    read -p "请输入TeleGram 机器人 TOKEN:" TOKEN
    read -p "请输入Socks5代理（仅仅是与Telegram服务器通讯，如服务器不在中国则请回车跳过）:" PROXY

    #sed 's/被替换的内容/要替换成的内容/g' file

    sed -i "s/<ADMIN>/${ADMIN}/g" /usr/local/FullTclash/resources/config.yml
    sed -i "s/<APIID>/${APIID}/g" /usr/local/FullTclash/resources/config.yml
    sed -i "s/<APIHASH>/${APIHASH}/g" /usr/local/FullTclash/resources/config.yml
    sed -i "s/<TOKEN>/${TOKEN}/g" /usr/local/FullTclash/resources/config.yml
    sed -i "s/<PROXY>/${PROXY}/g" /usr/local/FullTclash/resources/config.yml

    cat /usr/local/FullTclash/resources/config.yml
    echo -e "\n"
    echo -e "${red}"
    cat /usr/local/FullTclash/resources/config.yml
    echo -e "${plain} 这是您的配置文件，这是由最简配置文件生成的，如果需要更多自定义功能，请浏览 $yellow https://github.com/AirportR/FullTclash/blob/master/resources/config.yaml.example $plain"
    echo -e "$plain 配置文件路径：$yellow /usr/local/FullTclash/resources/config.yml $plain"

    echo -e "$yellow 正在安装PIP包环境，请稍等...$red"
    echo -e "$yellow 注：此处特别容易产生报错，遇到问题请截图询问。$plain"

    cd /usr/local/FullTclash/
    pip3 install -r /usr/local/FullTclash/requirements.txt

    if [[ $? -ne 0 ]]; then
    echo -e "$red 发生了这是一个错误，请检查您的python版本和pip版本是否正确。如不能自行解决，请截图提问。"
    exit 1
    fi

}


ENV_Install
GIT_Install
Install

