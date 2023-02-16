pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Deploy') {
            steps {
                withAWS(credentials: 'angelfr-aws-credentials') {
                   sshagent(['ssh-amazon']) {
                        sh 'terraform init'
                        sh 'terraform fmt'
                        sh 'terraform validate'
                        sh 'terraform apply -auto-approve'
                    }                    
                }
                
            }
        }
        

    }
}
