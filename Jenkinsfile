pipeline{
    agent{
        node{
            label "AGENT"
        }
    }
    parameters {
        string(name: 'version', description: 'version of the artifact to be deployed', defaultValue: '1.0.1')
    }
    
    options {
        ansiColor('xterm')
    }
    stages{
       
        stage("deploy"){
            steps{
                sh 'echo "deploying the catalogue"'
                sh "echo ${params.version}"
                
            }
        }

        stage("init"){
            steps{
                sh '''
                cd terraform 
                terraform init -reconfigure

                '''
            }
        }
        stage("plan"){
            steps{
                sh """
                    cd terraform 
                    terraform plan -var="package_version=${params.version}"
                """
            }
        }
        stage('Approve') {
            input {
                message "Should we continue with deployment?"
                ok "Yes, we should."
                submitter "sudhi"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            steps {
                echo "Hello, ${PERSON}, nice to meet you."
            }
        }

        stage("apply"){
            steps{
                sh """
                    cd terraform 
                    terraform apply -var="package_version=${params.version}" -auto-approve
                """
            }
        }
    }
    // post{
    //     always{
    //         deleteDir()
    //     }
    // }    
}