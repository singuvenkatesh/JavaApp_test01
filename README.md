# JavaApp_test01

for reference jenkins with nexus
https://appfleet.com/blog/publishing-artifacts-to-nexus-using-jenkins-pipelines/

install maven, create creds, install nexusArtifactUploader,pipeline-utility-steps plugins on jenkins

docker run -d --name jenkins-ci -p 8080:8080 jenkins/jenkins:lts

docker exec -i jenkins-ci cat /var/jenkins_home/secrets/initialAdminPassword

docker pull sonatype/nexus3

docker run -d --name nexus_repo -p 8081:8081 sonatype/nexus3

docker exec -i nexus_repo cat /nexus-data/admin.password

