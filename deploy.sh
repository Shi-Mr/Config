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
    if [ ! -d Config ]; then
        echo "Start downloading profile..."
        sudo git clone https://github.com/Shi-Mr/Config.git
        if [[ $? != 0 ]]; then
            exit 1
        fi
        echo "Profile download succeeded..."
    fi
    sudo mkdir -p {nginx/{vhost,conf,log},wwwroot}
    echo "Start copying profile..."
    sudo mv Config/Nginx/Conf/nginx.conf ./nginx/conf
    sudo mv Config/Nginx/Conf/default.conf ./nginx/vhost
    sudo mv Config/Docker-Compose/docker-compose.yml ./
    sudo mv Config/Nginx/Html/index.html ./wwwroot/
    echo "Profile copy successfully..."
    sudo rm -rf Config
fi

echo "Starting container..."
sudo docker-compose up -d
