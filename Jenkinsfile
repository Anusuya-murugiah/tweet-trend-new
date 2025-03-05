pipeline {
    agent { label 'slave' }  // Change 'slave' to your agent label
    stages {
        stage('Build') {
            steps {
                sh 'echo "Running on: $(hostname)"'
                sh 'mvn clean deploy'
            }
        }
    }
}
