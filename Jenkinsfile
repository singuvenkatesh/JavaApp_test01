pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        stage('clone') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/singuvenkatesh/JavaApp_test01.git'

            }

        }
        
        stage('Build') {
            steps {

                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"

            }

        }
    }
}
