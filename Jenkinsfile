pipeline{
    agent{
        node{
            label "AGENT"
        }
    }
    environment{
        version = ''
    }
    options {
        ansiColor('xterm')
    }
    stages{
       
        stage("deploy"){
            steps{
                sh 'echo "deploying the catalogue"'
                
            }
        }
    }
    // post{
    //     always{
    //         deleteDir()
    //     }
    // }    
}