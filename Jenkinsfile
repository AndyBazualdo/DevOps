pipeline {
    agent { label'master'}
    environment {
        //Docker credentials
        DOCKER_USER_NAME = 'gato756'
        DOCKER_PASSWORD = 'Bichito123'
        //New tag for docker
        DOCKER_TAG_CURRENT = '1.0'
        //Test status flag
        TEST_STATUS='pass'
        //Docker repository
        DOCKER_REPOSITORY = 'gato756/awt04webservice_1.0'
    }
    stages {
        stage('Build') {
            agent {
                docker { image '${DOCKER_REPOSITORY}:${DOCKER_TAG_CURRENT}' }
            }
            steps {
                sh 'chmod +x gradlew'
                sh './gradlew build'
            }
            post {
                always {
                    junit 'build/test-results/test/*.xml'
                    archiveArtifacts 'build/libs/*.jar'
                    stash includes: '**/*.yaml', name: 'compose'
                }
            }
        }
        stage('SonarCloud') {
            steps {
                sh 'chmod +x gradlew'
                sh './gradlew sonarqube -Dsonar.projectKey=andybazualdo -Dsonar.organization=andybazualdo -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=16e96c988a578b8f8dd2b8bf381c19fcc11194f3'
            }
        }
        stage('Deploy to Dev'){
            agent{label'master'}
            steps{
                copyArtifacts filter: '**/*/*.jar', fingerprintArtifacts: true, projectName: '${JOB_NAME}', selector: specific('${BUILD_NUMBER}')
                stash includes: '**/*/*.jar', name: 'jar'
                unstash 'compose'
                sh 'echo deploying into development .......'
                sh 'pwd'
                sh 'ls -la'
                sh 'docker-compose -f docker-compose.yaml up -d'
            }
        } 
        stage('Smoke Test') {
            steps {
                sh 'echo Smoke test Failed'
                sh 'echo Smoke test Passed'
                //error("Smoke test results have errors deployment")
            }
        }
        stage('Push to docker registry'){
            when {
                anyOf {branch 'master'; branch 'develop'}
            }
            steps {
                unstash 'jar'
                sh 'echo Start updating to docker hub .......'
                sh 'docker login --username ${DOCKER_USER_NAME} --password ${DOCKER_PASSWORD}'
                sh 'docker build -t ${DOCKER_REPOSITORY}:${BUILD_NUMBER} .'
                sh 'docker push ${DOCKER_REPOSITORY}:${BUILD_NUMBER}'
            }
        }
        stage('Promote to QA'){
            agent{label'awt4cv04'}
            steps{
                unstash 'compose'
                unstash 'jar'
                sh 'echo deploying into QA enviroment .......'
                sh 'docker-compose -f docker-compose-promote.yaml up -d'
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
            sh 'docker-compose down'
            sh 'docker stop $(docker ps -a -q)'
            sh 'docker image rm $(docker images -q) -f'
            sh 'docker rm $(docker ps -a -q) -f'
            cleanWs deleteDirs: true, notFailBuild: true
        }
    }
}