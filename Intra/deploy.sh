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

if [ ! -d nginx/conf.d ]; then
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
    sudo mkdir -p {nginx/{conf.d,log},wwwroot}
    echo "Start copying profile..."
    sudo mv ./Config/Intra/docker-compose.yml ./
    sudo mv ./Config/Intra/Nginx/Source/default.conf ./nginx/conf.d/
    echo "Profile copy successfully..."
    
    work_dir=/docker/Config/Intra/MySQL
    cd $work_dir
    echo "Building MySQL image..."
    sudo docker build -t mysql:intra-v1 .
    if [[ $? != 0 ]]; then
	exit 1
    fi

    work_dir=/docker/Config/Intra/PHP
    cd $work_dir
    echo "Building PHP image..."
    sudo docker build -t php:intra-v1 .
    if [[ $? != 0 ]]; then
	exit 1
    fi

    work_dir=/docker/Config/Intra/Nginx
    cd $work_dir
    echo "Building Nginx image..."
    sudo docker build -t nginx:intra-v1 .
    if [[ $? != 0 ]]; then
	exit 1;
    fi
fi

sudo chown -R $USER:$USER /docker

echo "Starting container..."
sudo docker-compose up -d
