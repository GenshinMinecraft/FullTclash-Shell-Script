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

