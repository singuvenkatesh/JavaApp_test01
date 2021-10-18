# JavaApp_test01

for reference jenkins with nexus
https://appfleet.com/blog/publishing-artifacts-to-nexus-using-jenkins-pipelines/

install maven, create creds, install nexusArtifactUploader,pipeline-utility-steps plugins on jenkins

docker run -d --name jenkins-ci -p 8080:8080 jenkins/jenkins:lts

docker exec -i jenkins-ci cat /var/jenkins_home/secrets/initialAdminPassword

docker pull sonatype/nexus3

docker run -d --name nexus_repo -p 8081:8081 sonatype/nexus3

docker exec -i nexus_repo cat /nexus-data/admin.password

# Docker Jenkins agent setup

Port 4243: Docker Remote API port
HostPort Range: 32768 to 60999, used by Docker to assign a host port for Jenkins to connect to the container
Login to server 2 where Docker is installed and open the docker service file /lib/systemd/system/docker.service. Search for ExecStart and replace that line with the following:
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock
Reload and restart Docker service
sudo systemctl daemon-reload
sudo service docker restart
Go to Jenkins Host server and execute
curl http://10.10.25.51:4243/version
Replace your Host IP with 10.10.25.51. You should receive output in JSON format as shown below.

That’s it! Now we will move towards creating a Jenkins agent docker image

Let’s build a new image from scratch.
SSHD Config File
Create a ‘sshd_config’ file and copy/paste the below sshd configuration settings into the file.
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
LoginGraceTime 120
PermitRootLogin yes
PubkeyAuthentication yes
UsePAM yes
Create a Docker File
Create a docker file (Dockerfile) and copy/paste the following commands in it and build an image
FROM ubuntu
RUN mkdir -p /var/run/sshd
RUN apt -y update
RUN apt install -y openjdk-8-jdk
RUN apt install -y openssh-server
RUN ssh-keygen -A
ADD ./sshd_config /etc/ssh/sshd_config
RUN echo root:password123 | chpasswd
CMD ["/usr/sbin/sshd", "-D"]
Above code, snippet does the following
Create a privilege separation directory for sshd services
Install open JDK and OpenSSH-server packages
Generate keys like RSA, DSA, ECDSA, ed25519 on the default location i.e. /etc/ssh/
Add ‘sshd_config’ to ‘/etc/ssh/sshd_config’
Read username: password from the stdin and update it on /etc/passwd
Start sshd services
Build an image
Run the command below in order to build the image from the docker file
$ docker image build -t docker-slave .
Launch a Container
$ docker run -d -ti -p 38787:22 docker-slave:latest
Test SSH Connection
$ ssh root@<machine_ip> -p 38787

