# docker-jenkins

Jenkins Docker镜像

## 一、构建镜像

```bash
git clone https://github.com/fifilyu/docker-jenkins.git
cd docker-jenkins
docker buildx build -t fifilyu/jenkins:latest .
```

## 二、开放端口

* sshd->22
* Jenkins->8080

## 三、启动容器（数据分离）

### 3.1 预先准备开放权限的数据和日志目录

```bash
sudo mkdir -p /data/jenkins/logs
sudo chmod -R 777 /data/jenkins
```

### 3.2 启动带目录映射的容器

```bash
docker run -d \
    --env LANG=en_US.UTF-8 \
    --env TZ=Asia/Shanghai \
    -e PUBLIC_STR="$(<~/.ssh/fifilyu@archlinux.pub)" \
    -p 1022:22 \
    -p 1808:8080 \
    -v /data/jenkins/:/var/lib/jenkins/.jenkins/ \
    -v /data/jenkins/logs:/var/log/jenkins/ \
    -h jenkins \
    --name jenkins \
    fifilyu/jenkins:latest
```

### 3.3 重置目录权限

```bash
# 目录降级读写权限
sudo chmod 755 /data/jenkins /data/jenkins/logs

# 使用容器内的jenkins用户和组的id重置目录用户组
uid=$(docker exec -it jenkins bash -c 'id -u jenkins' | tr -d '\r')
gid=$(docker exec -it jenkins bash -c 'id -g jenkins' | tr -d '\r')

sudo chown -R ${uid}:${gid} /data/jenkins

# 确认重置效果
ls -dl /data/jenkins && ls -al /data/jenkins
```

### 3.4 重启容器

*必须重启容器，否则容器无法读写映射目录*

```bash
docker restart jenkins
```

## 四、使用Jenkins

### 4.1 查看初始密码

```bash
sudo cat /data/jenkins/secrets/initialAdminPassword
```

### 4.2 访问Jenkins

http://localhost:1808/