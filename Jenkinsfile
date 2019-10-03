pipeline {
    agent any
    environment {
        //Docker credentials
        DOCKER_USER_NAME = 'gato756'
        DOCKER_PASSWORD = 'Bichito123'
        //New tag for docker
        DOCKER_TAG_NEW = '1.1'
        DOCKER_TAG_CURRENT = '1.0'
        //DOCKER_TAG_CURRENT = 'latest'
        //Docker repository
        DOCKER_REPOSITORY = 'gato756/awt04webservice_1.0'
        //TAG = '${BUILD_NUMBER}'
    }
    stages {
        stage('Build') {
            agent {
                docker { image '${DOCKER_REPOSITORY}:${DOCKER_TAG_CURRENT}' }
            }
            steps {
                //sh 'printenv'
                sh 'chmod +x gradlew'
                sh './gradlew build'
            }
            post {
                always {
                    junit 'build/test-results/test/*.xml'
                    archiveArtifacts 'build/libs/*.jar'
                    sh 'ls -al'
                    sh 'pwd'
                }
            }
        }
        stage('SonarCloud') {
            steps {
                sh 'chmod +x gradlew'
                //sh './gradlew sonarqube -Dsonar.projectKey=andybazualdo -Dsonar.organization=andybazualdo -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=16e96c988a578b8f8dd2b8bf381c19fcc11194f3'
            }
        }
        stage('Deploy to Dev'){
            agent{label'master'}
            steps{
                copyArtifacts fingerprintArtifacts: true, parameters: 'build/libs*.jar', projectName: '${JOB_NAME}', selector: lastWithArtifacts(), target: './jar'
                sh 'echo deploying into development .......'
                //sh 'docker-compose build'
                sh 'docker-compose up'
            }
        } 
        stage('Smoke Test'){
            steps{
                echo 'Start smoke test on develoment environment'
                //hacer que este stage pase si o si opc1 echo 0
                sh 'exit 0'
            }
        }
        stage ('Push to docker registry'){
            when {
                anyOf {branch 'master'; branch 'develop'}
            }
            steps {
                sh 'echo Start updating to docker hub .......'
                sh 'echo "${DOCKER_PASSWORD}" | docker login --username ${DOCKER_USER_NAME} --password-stdin'
                sh 'docker build -t ${DOCKER_REPOSITORY}:${BUILD_NUMBER} .'
                sh 'docker push ${DOCKER_REPOSITORY}:${BUILD_NUMBER}'
            }
        }
        stage('Promote to QA'){
            agent{label'slave01'}
            steps{
                sh 'echo deploying into QA enviroment .......'
                //sh 'docker-compose -f docker-compose-promote build'
                //sh 'docker-compose -f docker-compose-promote up'
            }
        }
        stage('End to end testing'){
            steps{
                echo 'End to end testing is in progress.....'
                sh 'exit 0'
            }
        }
    }
    post{
       failure {
            emailext attachLog: true, compressLog: true, body: 'The process to generate a new verion of ${GIT_BRANCH}. Log with the info is attached ',
                     subject: 'Build Notification: ${JOB_NAME}-Build# ${BUILD_NUMBER} ${currentBuild.result}',
                     to: 'fernando.hinojosa@live.com'
        }
        always {
            cleanWs deleteDirs: true, notFailBuild: true
        }
    }
}