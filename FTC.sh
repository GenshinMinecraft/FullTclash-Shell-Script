#!/bin/bash

# 本脚本用于在Debian系列系统管理FullTclash
# https://github.com/AirportR/FullTclash
# **********************
# Create Date 2023/4/25
# By GenshinMinecraft
# **********************
# 运行本脚本前需要先运行 wget -O install_FTC.sh "https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/install.sh" && bash install_FTC.sh
# 切勿单独运行

red='\033[0;31m'
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

read -p "序号选择：" num
case $num in
    0)
        wget -O /usr/bin/FTC "https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/FTC.sh"
        chmod +x /usr/bin/FTC
        echo "$green已成功更新并自动退出！"
        exit 0
        ;;
    1)
        systemctl daemon-reload
        systemctl start FullTclash
        echo "$green已成功启动FullTclash！"
        exit 0
        ;;
    2)
        systemctl daemon-reload
        systemctl stop FullTclash
        echo "$green已成功停止FullTclash！"
        exit 0
        ;;
    3)
        systemctl daemon-reload
        systemctl restart FullTclash
        echo "$green已成功重启FullTclash！"
        exit 0
        ;;
    4)
        systemctl disable FullTclash
        rm -rf /usr/local/FullTclash/ /etc/systemd/system/multi-user.target.wants/FullTclash.service /etc/systemd/system/FullTclash.service
        echo "$green已成功卸载FullTclash！"
        echo "如需彻底卸载本脚本，请手动执行 rm -rf /usr/bin/FTC "
        exit 0
        ;;
    *)
        echo "error"
esac
