# Config
<h3>LNMP环境配置信息:</h3>
执行Office文件夹下面的deploy.sh脚本，拉取官方镜像创建容器。<br />
执行Intra文件夹下面的deploy.sh脚本，根据MySQL、PHP、Nginx文件夹下面的Dockerfile文件创建容器。<br />
#创建LNMP环境<br />
```
/bin/bash deploy.sh
```
#重启LNMP环境<br />
```
/bin/bash deploy.sh restart
```
#停止LNMP环境<br />
```
/bin/bash deploy.sh stop
```
#启动LNMP环境<br />
```
/bin/bash deploy.sh start
```
#删除LNMP环境<br />
```
/bin/bash deploy.sh down
```
