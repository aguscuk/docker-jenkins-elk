FROM jenkins/jenkins:2.319.1-jdk11

USER root
RUN mkdir -p /var/lib/filebeat
RUN curl -o /tmp/filebeat-5.5.2-amd64.deb https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.5.2-amd64.deb && \
   dpkg -i /tmp/filebeat-5.5.2-amd64.deb &&  apt-get install

COPY filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod go-w /etc/filebeat/filebeat.yml

RUN apt-get update && apt-get install -y --no-install-recommends \
       apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]

USER root
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY jenkins-casc.yaml /usr/local/jenkins-casc.yaml
ENV CASC_JENKINS_CONFIG /usr/local/jenkins-casc.yaml
RUN mkdir -p /var/jenkins_home/jobs/test
COPY config.xml /var/jenkins_home/jobs/test/config.xml
