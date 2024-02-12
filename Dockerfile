FROM fifilyu/centos9:latest

ENV TZ Asia/Shanghai
ENV LANG en_US.UTF-8

##############################################
# buildx有缓存，注意判断目录或文件是否已经存在
##############################################

COPY file/etc/yum.repos.d/jenkins.repo /etc/yum.repos.d/jenkins.repo
COPY file/jenkins.io-2023.key /tmp/jenkins.io-2023.key

RUN rpm --import /tmp/jenkins.io-2023.key

RUN dnf makecache
RUN dnf install -y fontconfig java-17-openjdk
RUN dnf install -y jenkins
RUN usermod -s /bin/bash jenkins

RUN mkdir -p /var/log/jenkins /var/lib/jenkins/.jenkins/war

COPY file/var/lib/jenkins/.bash_profile /var/lib/jenkins/.bash_profile 
COPY file/var/lib/jenkins/.bashrc /var/lib/jenkins/.bashrc

RUN chown -R jenkins:jenkins /var/lib/jenkins/ /var/log/jenkins/

RUN rm -f /tmp/jenkins.io-2023.key
RUN dnf clean all

COPY file/usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

WORKDIR /root

EXPOSE 22 8080
