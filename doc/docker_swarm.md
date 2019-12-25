## docker swarm

## introduction

**swarm** 是一组可以管理 docker 容器的机器集群，在 swarm中的机器分两种类型：**Manager** 和 **Worker**，二者都可以运行容器，区别在于 Manager 拥有管理权，一些命令只能在 Manager 上执行。

一个 Swarm 集群至少拥有一个 Manager，若拥有多个，则只有一个 Leader，Leader挂掉后自动选举新的Leader；Worker 可以有零到多个

## start a swarm

```shell
docker  swarm init --advertise-addr 192.168.1.62
```

初始化一个swarm节点，并把当前执行命令的节点作为manage管理节点,具有集群的管理权

## add a worker 

```shell
docker swarm join --token SWMTKN-1-0x4sg0wticup88bx9ksajfiewkfjlaksdjfkld26y6mc2-di74xdrph5wxgv19dpqpm3xn8 192.168.1.62:2377
```

在另外一台机器上执行`docker join` 加入上一步创建的swarm集群，并成为worker节点，具有查看功能，但不具有管理这个swarm集群的功能

# docker stack

## introduction

**stack** 是构成特定环境中的 **service** 集合, 它是自动部署多个相互关联的服务的简便方法，而无需单独定义每个服务。

**stack file** 是一种 yaml 格式的文件，类似于 **docker-compose.yml** 文件，它定义了一个或多个服务，并定义了服务的环境变量、部署标签、容器数量以及相关的环境特定配置等

示例:

```yaml
version: "3.5"
services:
  lb:
    image: registry.eyexpo.org:5000/pro-app:staging
    deploy:
      replicas: 1
      resources:
        limits:
          cpus: "0.4"
          memory: 128M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
      - "443:443"
      - "8090:8090"
    dns: 192.168.6.221
    networks:
      - proxynet
networks:
  proxynet:
```

## 部署stack

`docker stack deploy -c docker-compose.yml eyexpoproxy`

## stack列表

```shell
~]$ docker stack ls
NAME                SERVICES            ORCHESTRATOR
eyexpoproxy         1                   Swarm
```



## stack服务列表

```shell
docker stack services [OPTIONS] STACK
~]$ docker stack services eyexpoproxy
ID                  NAME                MODE                REPLICAS            IMAGE                                      PORTS
7rxy4mazdryu        eyexpoproxy_lb      replicated          1/1                 registry.eyexpo.org:5000/pro-app:staging   *:80->80/tcp, *:443->443/tcp, *:8090->8090/tcp

```

查看stack中有哪些服务

## stack 任务列表查询

```shell
docker stack ps [OPTIONS] STACK
~]$ docker stack ps eyexpoproxy
ID                  NAME                   IMAGE                                      NODE                DESIRED STATE       CURRENT STATE           ERROR                              PORTS
nm1585i7t8op        eyexpoproxy_lb.1       registry.eyexpo.org:5000/pro-app:staging   stage0              Running             Running 23 hours ago

```

## stack删除

```shell
docker stack rm eyexporoxy
```
