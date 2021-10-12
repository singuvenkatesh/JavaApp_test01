pipeline {
    agent any
	environment{
	
	DOCKER_TAG = "${getLatestCommitId()}"
	}
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        stage('clone') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', url: 'https://github.com/singuvenkatesh/JavaApp_test01.git'

            }

        }
        
        stage('Build') {
            steps {

                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"

            }

        }
		
		stage('Docker - Build'){
			steps{
			   withCredentials([string(credentialsId: 'dockerpwd', variable: 'dockerpwd')]) {
					sh "docker login -u singuvenkatesh -p ${dockerpwd}"
			   }
			   
			   sh "docker build . -t singuvenkatesh/myweb:${DOCKER_TAG} "
			}
		}
		
		stage('Docker - Push'){
			steps{
			   sh "docker push singuvenkatesh/myweb:${DOCKER_TAG}"
			}
		}
		
		stage('Removed unused images'){
			steps{
			   sh "docker rmi \$(docker images | grep singuvenkatesh/myweb | awk '{print \$3}')"
			}
		}
	    
	    	stage('Deploy Patient App') {
   			 steps {
       			withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://172.31.80.57:8443']) {
				sh 'sed -i 's|DOCKER_TAG|${DOCKER_TAG}|g' deployment.yml'
				
				sh 'cat deployment.yml'
      				
				sh "kubectl create -f deployment.yml"
				
				sh "kubectl get pods"
				
				sh "kubectl create -f service.yml"
				
				sh "kubectl get svc"
    			}
           }
		
           }
    }
	
		
}

def getLatestCommitId(){
	def commitId = sh returnStdout: true, script: 'git rev-parse HEAD'
	return commitId
}
