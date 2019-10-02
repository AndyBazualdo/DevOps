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
        TAG = VersionNumber projectStartDate: '09/23/2019', versionNumberString: '${BUILD_NUMBER}', versionPrefix: 'v1.', worstResultForIncrement: 'FAILURE'
    }
    stages {
        stage('Build') {
            agent {
                docker { image '${DOCKER_REPOSITORY}:${DOCKER_TAG_CURRENT}' }
            }
            steps {
                sh 'printenv'
                sh 'chmod +x gradlew'
                sh './gradlew build'
                sh 'echo ${NODE_NAME}'
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
        stage('Copy Artifacts') {
            steps {
                sh 'echo Start Coping .......'
                sh 'ls -al'
                sh 'pwd'
                copyArtifacts fingerprintArtifacts: true, parameters: 'build/libs*.jar', projectName: '${JOB_NAME}', selector: lastWithArtifacts(), target: './jar'
                //sh 'ls -al jar'
                //sh 'docker ps -a'
            }
        }
        stage('Docker push develop') {
            when { branch "develop" }
            steps {
                sh 'ls -al'
                sh 'pwd'
                sh 'echo Start updating to docker hub .......'
                sh 'echo "${DOCKER_PASSWORD}" | docker login --username ${DOCKER_USER_NAME} --password-stdin'
                sh 'docker build -t ${DOCKER_REPOSITORY}:DEVELOP-${TAG} .'
                sh 'docker push ${DOCKER_REPOSITORY}:DEVELOP-${TAG}'
            }
        }
        stage('Docker push master') {
            when { branch "master" }
            steps {
                sh 'ls -al'
                sh 'pwd'
                sh 'echo Start updating to docker hub .......'
                sh 'echo "${DOCKER_PASSWORD}" | docker login --username ${DOCKER_USER_NAME} --password-stdin'
                sh 'docker build -t ${DOCKER_REPOSITORY}:${TAG} .'
                sh 'docker push ${DOCKER_REPOSITORY}:${TAG}'
            }
        }
        stage('Deploy to development'){
            agent{label'master'}
            steps{
                sh 'echo ${NODE_NAME}'
                sh 'echo deploying into development .......'
            }
        }        
        stage('Unit test'){
            steps{
                sh 'echo executing Unit tests .......'
            }
        }
        stage('Promote to QA'){
            agent{label'slave01'}
            steps{
                sh 'echo ${NODE_NAME}'
                sh 'echo deploying into QA enviroment .......'
            }
        }
        stage('Tests'){
            steps{
                sh 'echo  making test.......'
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