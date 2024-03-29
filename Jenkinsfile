node {
    // setup the global static configuration
    env.TIMESTAMP = new java.text.SimpleDateFormat('yyyyMMddHHmmss').format(new Date())
    def scmInfo = checkout scm
    commit_id = "${scmInfo.GIT_COMMIT}"
    shortCommit = commit_id[0..6]
    git_tag = "fres:${env.BRANCH_NAME}-${shortCommit}"
    docker_project="zumigo-hello-world"
    docker_registry="docker.io/library" 
}
pipeline {
    agent {
        label 'master'
    }
    options {
        skipDefaultCheckout()
    }
    stages {
        stage('Checkout') {
            steps {
                    deleteDir()
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "refs/heads/$BRANCH_NAME"]],
                        userRemoteConfigs: [[credentialsId: 'balaji-github-creds', url: 'https://github.com/balaji-msk/kube-test.git']]
                    ])
                }
         }
        stage('Publish Artifact') {
            steps {
                script {
                      docker.withRegistry('', 'balaji-github-creds') {
                            sh """
                                cd kube-test
                                mvn versions:set -DnewVersion=spring-boot-2-hello-world:1.0.${BUILD_NUMBER}-SNAPSHOT 
                                mvn clean install
                                docker build --rm --tag ${git_tag} .
                                docker tag ${git_tag} -${git_tag} ${docker_registry}/${docker_project}-${git_tag}
                                docker push ${docker_registry}/${docker_project}-${git_tag}
                            """
                        }
                    }
                }
            }
      }
}
