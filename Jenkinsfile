def registry = 'https://trialwp5ggf.jfrog.io/'
def imageName = 'trialwp5ggf.jfrog.io/valaxy-docker/ttrend'
def version = '2.1.2'
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
                    sh 'mvn clean deploy -Dmaven.test.skip=true'
            }
        }
      stage ('test'){
          steps  {
              sh 'mvn surefire-report:report'
          }
      }
      stage('SonarQube analysis') {
      environment {
          scannerHome = tool 'sonarqube-scanner' 
      }
      steps {
         withSonarQubeEnv('sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
           sh "${scannerHome}/bin/sonar-scanner"
         }
       }
     }
    stage('quality gate') { 
    steps {
        script {
            def qualityGate = waitForQualityGate(
                timeout: 120,  // Timeout in seconds (adjust as needed)
                abortPipeline: false  // Set abortPipeline to false to not abort if the quality gate fails
            )
            if (qualityGate.status != 'OK') {
                echo "Quality Gate failed, but continuing the pipeline because abortPipeline is set to false"
            }
        }
    }
  }
  stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "mvn-local/{1}",
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
                 docker.withRegistry(registry, 'jfrog-cred'){
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

  
