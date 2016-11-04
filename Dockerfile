from maven:3-jdk-7


RUN apt update && apt install -y python-virtualenv ant ant-optional \
      apt-transport-https \
      ca-certificates \
      curl \
      lxc \
      iptables

# Tribute to https://curlpipesh.tumblr.com
RUN curl -sSL https://get.docker.com/ | sh

# stolen from jpetazzo/dind
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

CMD ["wrapdocker"]

