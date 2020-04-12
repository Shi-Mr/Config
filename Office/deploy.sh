#!bin/bash

if [[ -n $1 ]]; then
    work_dir=/docker
    cd $work_dir

    #启动容器
    if [[ $1 = "start" ]]; then
        sudo docker-compose up -d
        exit 1
    fi
    #停止容器
    if [[ $1 = "stop" ]]; then
        sudo docker-compose stop
        exit 1
    fi
    #重启容器
    if [[ $1 = "restart" ]]; then
        sudo docker-compose restart 
        exit 1
    fi
    #删除环境
    if [[ $1 = "remove" ]]; then
        sudo docker-compose down
        exit 1
    fi
fi

read -t 30 -p "Git,Docker and Docker-Compose installed?[y/N]" result
if [ $result != "y" ]; then
    echo "Installation interruption"
    exit 1;
fi

work_dir=/
cd $work_dir

if [ ! -d /docker/ ]; then
    sudo mkdir docker
fi

work_dir=/docker
cd $work_dir

if [ ! -f nginx/conf/nginx.conf ]; then
    echo "Start downloading profile..."
    if [ ! -d Config ]; then
        sudo git clone https://github.com/Shi-Mr/Config.git
    else
	sudo git pull
    fi
    if [[ $? != 0 ]]; then
	exit 1
    fi
    echo "Profile download succeeded..."
    sudo mkdir -p {nginx/{vhost,conf,log},wwwroot}
    echo "Start copying profile..."
    sudo mv Config/Office/Source/nginx.conf ./nginx/conf
    sudo mv Config/Office/Source/default.conf ./nginx/vhost
    sudo mv Config/docker-compose.yml ./
    sudo mv Config/Office/Source/index.html ./wwwroot/
    echo "Profile copy successfully..."
fi

echo "Starting container..."
sudo docker-compose up -d
