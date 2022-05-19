/* import shared library */
@Library('shared-library')_

pipeline {
	environment {
		ID_DOCKER = "drackorr"
		IMAGE_NAME = "mini_projet"
		IMAGE_TAG = "latest"
		STAGING = "mini_projet-staging"
		PRODUCTION = "mini_projet-production"
		PORT = "80"
	}
	agent none
	stages {
		stage('Construit image') {
			agent any
			steps {
				script {
					sh 'docker build -t $ID_DOCKER/$IMAGE_NAME:$IMAGE_TAG .'
				}
			}
		}
		
		stage('Lance le container base sur le build de image') {
			agent any
			steps {
				script {
					sh '''
						docker run --name $IMAGE_NAME -d -p 80:80 -e $PORT $ID_DOCKER/$IMAGE_NAME:$IMAGE_TAG
						sleep 5
					'''
				}
			}
		}

		stage('Test image') {
			agent any
			steps {
				script {
					sh '''
						curl http://192.168.40.61 | grep -q "Welcome"
					'''
				}
			}
		}

		stage('Nettoie le Container') {
			agent any
			steps {
				script {
					sh '''
						docker stop $IMAGE_NAME
						docker rm $IMAGE_NAME
					'''
				}
			}
		}
		
		stage('Login et envoi au docker hub') {
			agent any
			environment {
				DOCKER_PASSWORD = credentials('docker_password')
			}	
			steps {
				script {
					sh '''
						docker login -u="$ID_DOCKER" -p="${DOCKER_PASSWORD}"
						docker image push $ID_DOCKER/$IMAGE_NAME:$IMAGE_TAG
					'''
				}
			}
		}		
		
				
		stage('Pousse image dans staging et la deploie') {
			when {
					expression { GIT_BRANCH == 'origin/main' }
				}
			agent any
			environment {
				HEROKU_API_KEY = credentials('heroku_api_key')
			}
			steps {
				script {
					sh '''
						heroku container:login
						heroku create $STAGING || echo "*project already exist"
						heroku container:push -a $STAGING web
						heroku container:release -a $STAGING web
					'''
				}
			}
			
		}
		
		stage('Pousse image dans production et la deploie') {
			when {
					expression { GIT_BRANCH == 'origin/main' }
				}
			agent any
			environment {
				HEROKU_API_KEY = credentials('heroku_api_key')
			}
			steps {
				script {
					sh '''
						heroku container:login
						heroku create $PRODUCTION || echo "*project already exist"
						heroku container:push -a $PRODUCTION web
						heroku container:release -a $PRODUCTION web
					'''
				}
			}
			
		}
		
	}
	
    post {
		always {
			script {
				slackNotifier currentBuild.result
			}
		}  
    }
}
