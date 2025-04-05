pipeline {
    agent {
        label 'slave' 
    }
   /* environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }*/
    tools {
      jdk 'JDK17'
      maven 'MAVEN3'
    }
  stages {
        stage('code checkout') {
            steps {
                git branch: 'main' , url: 'https://github.com/Anusuya-murugiah/tweet-trend-new.git'
            }
        }
        stage('build the code') {
            steps {
                    sh 'echo "Running on: $(hostname)"'
                    sh 'mvn -version'
                    sh 'mvn clean deploy'
            }
        }  
  } 


  
}

  
