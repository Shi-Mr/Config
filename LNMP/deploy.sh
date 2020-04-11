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
        sudo docker-compose stop
        sudo docker-compose rm

        work_dir=/
        cd $work_dir
        sudo rm -rf /docker

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
    sudo mkdir -p {nginx/{conf,log},wwwroot}
    echo "Start copying profile..."
    sudo mv ./Config/LNMP/Nginx/Conf ./nginx/conf
    sudo mv ./Config/LNMP/docker-compose.yml ./
    sudo mv ./Config/LNMP/Nginx/Html/index.html ./wwwroot/
    echo "Profile copy successfully..."
    
    work_dir=/docker/Config/LNMP
    cd $work_dir
    echo "Building MySQL image..."
    sudo docker build -f ./MySQL/Dockerfile -t mysql:8.0 .
    if [[ $? != 0 ]]; then
	exit 1
    fi

    echo "Building PHP image..."
    sudo docker build -f ./PHP/Dockerfile -t php:7.2-fpm .
    if [[ $? != 0 ]]; then
	exit 1
    fi

    echo "Building Nginx image..."
    sudo docker build -f ./Nginx/Dockerfile/Dockerfile -t nginx:1.16 .
    if [[ $? != 0 ]]; then
	exit 1;
    fi
    
    sudo rm -rf Config
fi

echo "Starting container..."
sudo docker-compose up -d
