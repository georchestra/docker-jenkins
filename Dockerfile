FROM jenkins:2.7.2

USER root
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates \
  python-virtualenv ant ant-optional git

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-engine
RUN addgroup jenkins docker
RUN service docker start
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

