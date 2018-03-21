from maven:3-jdk-8


RUN apt update && apt install -y python-virtualenv ant ant-optional \
      apt-transport-https ca-certificates curl lxc iptables         \
      reprepro rpm fakeroot file createrepo python-pip              \
      && rm -rf /var/lib/apt/lists/*

RUN pip install jstools && ln -s /usr/local/bin/jsbuild /bin/jsbuild
# Tribute to https://curlpipesh.tumblr.com
RUN curl -sSL https://get.docker.com/ | sh

# stolen from jpetazzo/dind
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

ADD ./*-build.sh /usr/src/

ENV LC_ALL C.UTF-8

CMD ["wrapdocker"]

