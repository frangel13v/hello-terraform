pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Deploy') {
            steps {
                withAWS(credentials:'ruben-aws-credentials'){
                    sh 'terraform fmt'
                    sh 'terraform validate'
                    sh 'terraform apply -auto-approve'
                }
                
            }
        }
        

    }
}
