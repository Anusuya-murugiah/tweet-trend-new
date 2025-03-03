def registry = 'https://anusuya.jfrog.io'
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
    stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog"
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
    
 }  
  
}
