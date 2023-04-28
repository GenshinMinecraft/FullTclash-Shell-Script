#/bin/bash

cur_dir=$HOME

# 本脚本用于在Termux安装FullTclash
# 十分感谢开源工作者付出
# https://github.com/AirportR/FullTclash
# **********************
# Create Date 2023/4/25
# By GenshinMinecraft
# **********************

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'


echo -e "$green如果在安装过程中遇到问题，请在FullTclash官方TG频道反馈！$plain"

WARNING() {
	echo -e "$red本脚本仅适用与TERMUX ARM64安装FullTclash，请勿使用其他系统安装，如不想安装，请在5sec内按下Ctrl+C！$plain"
}

INSTALL_ENV() {
	echo -e "${yellow}正在进行环境安装，如遇到需要回复内容时，请直接回车。${plain}"
	apt update -y
	apt upgrade -y

	pkg install python python-pillow python-cryptography golang screen git wget curl -y

	if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行pkg安装软件包时发生了错误，请检查您的系统版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi
    
    type python3

    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!Python环境尚未正确安装好，请检查是否已安装python3.9+如不能自行解决，请截图提问。!!!"
    exit 1
    fi

    type pip3

    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!Python的Pip环境尚未正确安装好，请检查是否已安装python3.8+以及Pip。如不能自行解决，请截图提问。!!!"
    exit 1
    fi

    CHECK_PYTHON_VERSION

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
    cd $cur_dir/
    rm -rf FullTclash
    #git clone https://ghproxy.com/https://github.com/AirportR/FullTclash.git
    git clone https://github.com/AirportR/FullTclash.git

    if [[ $? -ne 0 ]]; then
    echo -e "$yellow检测到无法连接到GitHub服务器，开始使用反代源进行安装。$plain"
    git clone https://ghproxy.com/https://github.com/AirportR/FullTclash.git
    fi
    
    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'git clone https://github.com/AirportR/FullTclash.git'时发生了这是一个错误，请检查您是否安装了git以及git版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi
    
    cd ${cur_dir}
}

Install() {
    cd ~/FullTclash/resources
    echo -e "${yellow}接下来是编辑配置文件，编辑错误可能会导致无法启动，甚至崩溃，请确保您的主机已经安装好环境！$plain"
    #curl https://ghproxy.com/https://raw.githubusercontent.com/GenshinMinecraft/FullTclash-Shell-Script/main/config.yaml -O ~/FullTclash/resources/config.yaml
    wget https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/config.yaml -O ~/FullTclash/resources/config.yaml
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

    sed -i "s/<ADMIN>/${ADMIN}/g" ~/FullTclash/resources/config.yaml
    sed -i "s/<APIID>/${APIID}/g" ~/FullTclash/resources/config.yaml
    sed -i "s/<APIHASH>/${APIHASH}/g" ~/FullTclash/resources/config.yaml
    sed -i "s/<TOKEN>/${TOKEN}/g" ~/FullTclash/resources/config.yaml
    sed -i "s/<PROXY>/${PROXY}/g" ~/FullTclash/resources/config.yaml

    cat ~/FullTclash/resources/config.yaml
    echo -e "\n"
    echo -e "${red}"
    cat ~/FullTclash/resources/config.yaml
    echo -e "${plain} 这是您的配置文件，这是由最简配置文件生成的，如果需要更多自定义功能，请浏览 $yellow https://github.com/AirportR/FullTclash/blob/master/resources/config.yaml.example $plain"
    echo -e "$plain 配置文件路径：$yellow ~/FullTclash/resources/config.yaml $plain"

    echo -e "$yellow 正在安装PIP包环境，请稍等...$red"
    echo -e "$yellow 注：此处特别容易产生报错，遇到问题请截图询问。$plain"

    cd ~/FullTclash/
	wget "https://raw.githubusercontents.com/GenshinMinecraft/FullTclash-Shell-Script/main/requirements-termux.txt" -O ~/FullTclash/requirements.txt
    pip3 install -r ~/FullTclash/requirements.txt

    if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'pip3 install -r ~/FullTclash/requirements.txt'时发生了这是一个错误，请检查您的python版本和pip版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi
}

GOBUILD() {
	echo -e "$yellow开始编译fulltclash.go动态链接库$plain"
	rm -rf ~/FullTclash/libs/fulltclash.so ~/FullTclash/libs/fulltclash.h ~/FullTclash/libs/fulltclash.dll
	mkdir ~/TMP

	cd ~/TMP

	go mod init TMP

	if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'go mod init TMP'时发生了这是一个错误，请检查您是否安装了golang以及golang版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi

	go mod tidy

	if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'go mod tidy'时发生了这是一个错误，请检查您是否安装了golang以及golang版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi

	cp -afr ~/FullTclash/libs/fulltclash.go ~/FullTclash/libs/rootCA.crt ~/TMP/
	go build -buildmode=c-shared -o fulltclash.so ~/TMP/fulltclash.go
	
	if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'go build -buildmode=c-shared -o fulltclash.so ~/TMP/fulltclash.go'时发生了这是一个错误，请检查您是否安装了golang以及golang版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi

	mv ~/TMP/fulltclash.so ~/TMP/fulltclash.h ~/FullTclash/libs/

	echo -e "$green编译完成，已替换默认fulltclash.so$plain"
}

SCREEN_SETUP() {
	screen -dmS FTC && screen -x -S FTC -p 0 -X stuff "cd ~/FullTclash && python3 main.py" && screen -x -S test -p 0 -X stuff $'\n'
	
	if [[ $? -ne 0 ]]; then
    echo -e "$red !!!在执行'screen'时发生了这是一个错误，请检查您的python版本和pip版本是否正确。如不能自行解决，请截图提问。!!!"
    exit 1
    fi

	echo -e "$green成功并启动FullTclash！$plain"
}


WARNING
INSTALL_ENV
GIT_Install
Install
GOBUILD
SCREEN_SETUP


