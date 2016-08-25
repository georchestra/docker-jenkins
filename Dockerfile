FROM jenkins:2.7.2

USER root
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates \
  python-virtualenv ant ant-optional git

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-engine \
  && rm -rf /var/lib/apt/lists/*

RUN addgroup jenkins docker

RUN /usr/local/bin/install-plugins.sh ant antisamy-markup-formatter authentication-tokens config-file-provider \
      credentials cvs docker-build-step docker-commons external-monitor-job                                    \
      git git-changelog git-client icon-shim javadoc job-dsl junit ldap mailer                                 \
      matrix-auth matrix-project maven-plugin pam-auth scm-api script-security                                 \
      ssh ssh-agent ssh-credentials ssh-slaves subversion token-macro translation                              \
      windows-slaves workflow-step-api parameterized-trigger

