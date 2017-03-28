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

# Caveats

On some jenkins setups, the build can be mounted on very long paths as working
directory, this could end up with the following issue when maven deals with
jsbuild JS minification:

https://github.com/pypa/virtualenv/issues/596

If this is the case, the workaround can be to use the globally-provided jsbuild
(see Dockerfile), then to replace build.sh in the geOrchestra source tree by
the ones in `/usr/src`.

The following step can be used to hotfix the `build.sh` scripts in your Jenkinsfile:

```
  stage('hotfix shell scripts in geOrchestra sources') {
    // Replace jsbuild.sh to to circumvent silly path names
    sh """cp /usr/src/extractorapp-build.sh ./extractorapp/jsbuild/build.sh"""
    sh """cp /usr/src/mapfishapp-build.sh ./mapfishapp/jsbuild/build.sh"""
  }
```
