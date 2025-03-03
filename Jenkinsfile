pipeline {
    agent {
        label 'slave' 
    }
    environment {
        PATH = "/opt/apache-maven-3.9.2/bin:$PATH"
    }

    stages {
        stage('code checkout') {
            steps {
                git branch: 'main' , url: 'https://github.com/Anusuya-murugiah/tweet-trend-new.git'
            }
        }
        stage('build the code') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
    
    
    
}
