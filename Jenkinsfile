pipeline {
    agent any
    options([
    parameters([
        activeChoiceReactiveParam(name: 'FILE',
            choices: 'ls k8s/*.yaml',
            description: 'Choose YAML file to apply/delete',
            script: [
                $class: 'GroovyScript',
                scriptSource: [
                    $class: 'ScriptSourceFromInline',
                    inline: 'return [""] + readFile("k8s/*.yaml").split("\\n")'
                ]
            ]
        ),
        choice(name: 'ACTION', choices: ['APPLY', 'DELETE', 'APPLY_ALL', 'DELETE_ALL'], description: 'What action should be taken?'),
        choice(name: 'AGENT', choices: ['agent1', 'agent2', 'jenkinsmaster'], description: 'Which agent should perform the action?')
        ])
    ])
    environment {
        AWS_PROFILE = 'vscode'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm  // This checks out the Jenkinsfile's own repository by default
            }
        }  
        stage('Set Kubeconfig') {
            steps {
                script {
                    // Configure sudo kubectl for the EKS cluster
                    sh "sudo aws eks update-kubeconfig --name eks --profile $AWS_PROFILE"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    switch(params.ACTION) {
                        case 'APPLY':
                            sh "sudo kubectl apply -f ${params.FILE}"
                            break

                        case 'DELETE':
                            sh "sudo kubectl delete -f ${params.FILE}"
                            break

                        case 'APPLY_ALL':
                            sh "sudo kubectl apply -f /k8s/"
                            break

                        case 'DELETE_ALL':
                            sh "sudo kubectl delete -f /k8s/"
                            break

                        default:
                            echo "Invalid action!"
                            break
                    }
                }
            }
        }
    }
    post {
    success {
        script {
            echo "Fetching services from the cluster..."
            def getServicesOutput = sh(script: "sudo kubectl get svc", returnStdout: true).trim()
            echo "Services:\n${getServicesOutput}"

            echo "\nDescribing services..."
            def describeServicesOutput = sh(script: "sudo kubectl describe svc", returnStdout: true).trim()
            echo "Service Descriptions:\n${describeServicesOutput}"
        }
    }
    always {
        echo "Pipeline execution complete!"
        }
    }
}
