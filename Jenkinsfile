def registry = 'https://anusuya.jfrog.io'
def imageName = 'anusuya.jfrog.io/valaxy/ttrend'
def version = '2.1.2'
pipeline {
    agent {
        label 'slave' 
    }
   /* environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }*/

    stages {
        stage('code checkout') {
            steps {
                git branch: 'main' , url: 'https://github.com/Anusuya-murugiah/tweet-trend-new.git'
            }
        }
        stage('build the code') {
            steps {
                withEnv(["PATH=/opt/apache-maven-3.9.6/bin:$PATH"]) {
                    sh 'echo "Running on: $(hostname)"'
                    sh 'mvn -version'
                    sh 'mvn clean deploy'
                }
            }
        }     
    stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"frog_token"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "maven-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            }
        }   
    }   
    stage ('docker build') {
        steps {
            script {
                  echo '<--------------- Docker Build Started --------------->'
                  app =docker.build(imageName+":"+version)
                  echo '<--------------- Docker Build ended  --------------->'
            }
        }
    }
    stage ('docker publish') {
        steps {
            script {
                 echo '<--------------- Docker Publish Started --------------->'  
                 docker.withRegistry(registry, 'frog_token'){
                     app.push()
                 }
                echo '<--------------- Docker Publish Ended --------------->'  
            }
        }
    }
    stage ('deploy') {
        steps {
            script {
               echo '<--------------- helm install Started --------------->' 
                sh 'helm install ttrend ttrend-0.1.0.tgz'
                 echo '<--------------- helm install ended --------------->' 
            }
        }
    }
    
 }  
  
}
