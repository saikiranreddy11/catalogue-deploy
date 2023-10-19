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
                sh '''
                    cd terraform 
                    terraform plan -var="package_version=${params.version}"
                '''
            }
        }

        stage("apply"){
            steps{
                sh '''
                    cd terraform 
                    terraform apply -auto-approve -var="package_version=${params.version}"
                '''
            }
        }
    }
    // post{
    //     always{
    //         deleteDir()
    //     }
    // }    
}