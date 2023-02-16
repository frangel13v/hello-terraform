pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build'
                sh "git tag 1.0.${BUILD_NUMBER}"
                sshagent(['ssh-github']) {
                    sh "git push --tags"
                }
                sh "docker tag ghcr.io/frangel13v/hello-2048/hello2048:v1 ghcr.io/frangel13v/hello-2048/hello2048:1.0.${BUILD_NUMBER}"
            }
        }
        stage('Package') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'CR_PAT')]) {
                    sh "echo $CR_PAT | docker login ghcr.io -u frangel13v --password-stdin"
                    echo "docker-compose push....."
                    echo "docker push ghcr.io/frangel13v/hello-2048/hello2048:1.0.${BUILD_NUMBER}"
                }
                sh "docker push ghcr.io/frangel13v/hello-2048/hello2048:v1"
            }
        }
        stage('Deploy') {
            steps {
                sshagent(['ssh-amazon']) {
                    sh """
                        ssh -o "StrictHostKeyChecking no" ec2-user@ec2-54-216-113-106.eu-west-1.compute.amazonaws.com
                        docker pull ghcr.io/frangel13v/hello-2048/hello2048:v1
                        docker run -d --rm -p 80:80 ghcr.io/frangel13v/hello-2048/hello2048:v1
                    """
                }
            }
        }

    }
}
