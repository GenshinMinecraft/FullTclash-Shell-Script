#!/bin/shell

# 本脚本用于在Debian系列系统安装FullTclash
# 系统检测脚本源自X-ui项目的install.sh，十分感谢开源工作者付出
# https://github.com/AirportR/FullTclash
# **********************
# Create Date 2023/08/17
# By GenshinMinecraft
# **********************

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "请使用root用户运行此脚本" && exit 1

echo -e "$green如果在安装过程中遇到问题，请在FullTclash官方TG频道反馈！$plain"

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
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
    echo "$red 本软件不支持 32 位系统(x86)，请使用 64 位系统(x86_64)，如果检测有误，请联系作者 $plain"
    exit -1
fi

# Choois Setup Mode

echo -e "$yellow欢迎使用此FullTclash安装脚本，请选择安装方式"
echo -e "1. Docker安装(适用于全部Linux系统)"
echo -e "2. Screen安装(适用于没有Systemd的系统,如Openwrt/Alpine)"
echo -e "3. Systemd安装(适用于有Systemd的系统,目前大部分发行版已支持)"
echo -e "4. 退出"
echo -e "注:使用Docker安装时请先安装Docker环境,Systemd/Screen安装请确保系统软件源拥有Py3.9+"
echo -e "$green推荐使用Docker安装! $plain"
echo -e 
read -rp "请输入选项:" StartInput1
case $StartInput1 in
    1) echo 1 ;;
    2) echo 2 ;;
    3) echo -e "$green开始使用Systemd进行安装！$plain";wget 'https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/install-systemd.sh';bash install-systemd.sh;;
    0) exit -1 ;;
    *) echo -e "$red输入错误，自动退出！$plain"; exit -1 ;;
esac
