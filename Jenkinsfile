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
                sh 'terraform init -reconfigure'
            }
        }
        stage("plan"){
            steps{
                sh 'terraform plan'
            }
        }
    }
    // post{
    //     always{
    //         deleteDir()
    //     }
    // }    
}