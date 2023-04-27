#!/bin/bash

# 本脚本用于在Debian系列系统管理FullTclash
# https://github.com/AirportR/FullTclash
# **********************
# Create Date 2023/4/25
# By GenshinMinecraft
# **********************
# 运行本脚本前需要先运行 wget -O install_FTC.sh "https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/install.sh" && bash install_FTC.sh
# 切勿单独运行

export red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "请使用root用户运行此脚本" && exit 1


echo -e "$red FullTclash 管理脚本$yellow
0) 退出并更新脚本
1) 启动FullTclash
2) 停止FullTclash
3) 重启FullTclash
4) 卸载FullTclash
5) 设置开机启动
6) 设置开机不启动
7) 编辑配置文件（VIM）$plain
"

systemctl status FullTclash | grep -E 'running' >> /dev/null
if [[ $? -ne 0 ]]; then
    echo -e "当前状态：$red未启动！$plain"
else
    echo -e "当前状态：$green已启动！$plain"
fi

read -p "序号选择：" num
case $num in
    0)
        wget -O /usr/bin/FTC "https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/FTC.sh"
        chmod +x /usr/bin/FTC
        echo -e "$green已成功更新并自动退出！$plain"
        exit 0
        ;;
    1)
        systemctl daemon-reload
        systemctl start FullTclash
        echo -e "$green已成功启动FullTclash！$plain"
        exit 0
        ;;
    2)
        systemctl daemon-reload
        systemctl stop FullTclash
        echo -e "$green已成功停止FullTclash！$plain"
        exit 0
        ;;
    3)
        systemctl daemon-reload
        systemctl restart FullTclash
        echo -e "$green已成功重启FullTclash！$plain"
        exit 0
        ;;
    4)
        systemctl disable FullTclash
        rm -rf /usr/local/FullTclash/ /etc/systemd/system/multi-user.target.wants/FullTclash.service /etc/systemd/system/FullTclash.service
        echo -e "$green已成功卸载FullTclash！$plain"
        echo -e "如需彻底卸载本脚本，请手动执行 rm -rf /usr/bin/FTC "
        exit 0
        ;;
    5) 
        systemctl enable FullTclash
        echo -e "$green已成功设置开机启动FullTclash！$plain"
        exit 0
        ;;
    6) 
        systemctl disable FullTclash
        echo -e "$green已成功设置开机不启动FullTclash！$plain"
        exit 0
        ;;
    7) 
        echo -e "$yellow注：您正在进行危险操作，请注意配置文件格式，编辑不当会导致启动错误！$plain"
        sleep 1
        YN=0
        read -p "你确定吗(Y/N)：" YN 
        
        if [[ $YN == "y" || $YN == "Y" || $YN == "" ]]
        then
        echo -e "$yellow下载config.yaml.example中$plain" 
        wget -O /usr/local/FullTclash/resources/config.yaml.example "https://raw.githubusercontents.com/AirportR/FullTclash/master/resources/config.yaml.example" 
        apt install vim -y
        
        echo -e "$red在编辑完成后请保存并退出，将会自动重启与备份先前的config.yaml$plain"
        sleep 3
        vim /usr/local/FullTclash/resources/config.yaml.example

        mv /usr/local/FullTclash/resources/config.yaml /usr/local/FullTclash/resources/config.yaml.bak
        mv /usr/local/FullTclash/resources/config.yaml.example /usr/local/FullTclash/resources/config.yaml
        echo -e "$yellow编辑完成，已备份先前config.yaml为config.yaml.bak。如当前config.yaml无法启动，将自动切换回config.yaml.bak$plain"

        systemctl daemon-reload
        systemctl restart FullTclash
        echo -e "$green正在尝试使用新配置文件进行启动，请稍等15sec......$plain"
        sleep 15

        systemctl status FullTclash | grep -E 'running' >> /dev/null
        if [[ $? -ne 0 ]]; then
        echo -e "$red !!!错误！无法加载新配置文件，即将切换为旧配置!!!$plain"
        mv /usr/local/FullTclash/resources/config.yaml.bak /usr/local/FullTclash/resources/config.yaml
        systemctl restart FullTclash
        echo -e "$green已切换为旧配置并启动$plain"
        exit 0
        fi
        echo -e "$green已更新config.yaml，可正常使用！$plain"
        fi
        exit 0
        ;;
    *)
        echo -e "$red输入命令有误，请重试！$plain"
        exit 1
esac
