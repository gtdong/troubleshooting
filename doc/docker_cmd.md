# docker cmd

## 查看
```shell
1.查看docker版本
docker version

2.查看正在运行中的container  
docker ps
docker ps -a 查看所有（包括已经停止的容器）

3.查看当前有些什么images  
docker images

4.查看容器的CPU，内存，IO 等使用信息
docker stats

```
## 运行
```shell
1.启动docker  
docker run -d -i -t <imageID> /bin/bash 

2.进入正在运行中的container  
docker exec -it container_id bash
docker exec -it container_id ash (bash进不去时用这个)

3.关闭、启动、重启  
docker stop container_id 停止容器
docker start container_id 启动容器
docker restart container_id 重启容器

4.停止所有的container  
docker stop $(docker ps -a -q)


```
## 删除
```shell
1.删除所有container  
docker rm $(docker ps -a -q)

2.删除images，通过image的id来指定删除谁  
docker rmi <image id>

3.想要删除untagged images，也就是那些id为<None>的image的话可以用  
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
  
4.要删除全部image的话  
docker rmi $(docker images -q)
```
