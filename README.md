# About

This is a docker image with maven & other tools used to compile the geOrchestra suite. It has been created to be used in a docker pipeline (jenkinsfile based) build, and uses some tools stolen from the Docker-in-a-Docker (DIND) image.

# Jenkinsfile

Below is an example of Jenkinsfile that can be used to drive a Jenkins pipeline job:

```groovy
node('docker') {
    stage('docker pulling image builder image') {
        sh 'docker pull georchestra/jenkins-builder'
    }
    withDockerContainer(image: 'georchestra/jenkins-builder', args: "--privileged") {
        stage('Preparation') {
            git url:'https://github.com/georchestra/georchestra.git'
            sh "git submodule update --init --recursive"
            sh 'service docker start'
        }
        stage('build necessary modules') {
            sh """mvn  -Dmaven.test.failure.ignore clean install               \
       --non-recursive"""

            sh """mvn clean install -pl config                                 \
       -Dmaven.javadoc.failOnError=false"""

            sh """mvn clean install -pl commons,epsg-extension                 \
       -Dmaven.javadoc.failOnError=false"""
        }

        stage('build mapfishapp') {
            sh """mvn -Dmaven.test.failure.ignore clean install               \
         -Dmaven.javadoc.failOnError=false                                    \
         -pl mapfishapp"""
        }
    }
}
```
