# Config
LNMP环境配置信息<br />

2020-04-11<br />
增加LNMP环境docker-compose.yml文件<br />
增加Nginx的配置文件<br />

增加傻瓜式脚本-官方镜像<br />
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

2020-04-12<br />
增加LNMP环境的Dockerfile文件(LNMP文件夹)，操作命令同上。

