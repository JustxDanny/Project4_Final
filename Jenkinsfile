properties([
  parameters([
    // First parameter: Choice of YAML files or SELECT_ALL
    [
      $class: 'ChoiceParameter',
      choiceType: 'PT_SINGLE_SELECT',
      name: 'FILE',
      script: [
        $class: 'GroovyScript',
        fallbackScript: [
          classpath: [],
          sandbox: true,
          script: 'return ["Error"]'
        ],
        script: [
          classpath: [],
          sandbox: true,
          script: 'return ["SELECT_ALL"] + new File("k8s/").list().findAll { it.endsWith(".yaml") }'
        ]
      ]
    ],
    
    // Second parameter: Action based on file choice
    [
      $class: 'CascadeChoiceParameter',
      choiceType: 'PT_SINGLE_SELECT',
      name: 'ACTION',
      referencedParameters: 'FILE',
      script: [
        $class: 'GroovyScript',
        fallbackScript: [
          classpath: [],
          sandbox: true,
          script: 'return ["Error"]'
        ],
        script: [
          classpath: [],
          sandbox: true,
          script: '''
          if (FILE == "SELECT_ALL") {
            return ["APPLY_ALL", "DELETE_ALL"]
          } else {
            return ["APPLY", "DELETE"]
          }
          '''
        ]
      ]
    ],
    
    // Third parameter: Choice of AGENT
    choice(name: 'AGENT', choices: ['agent1', 'agent2', 'jenkinsmaster'], description: 'Which agent should perform the action?')
  ])
])

pipeline {
    agent any

    environment {
        AWS_PROFILE = 'vscode'
    }
    stages {
        stage('Deploy') {
            steps {
                echo "Selected File: ${params.FILE}"
                echo "Selected Action: ${params.ACTION}"
                echo "Selected Agent: ${params.AGENT}"
            }   
        }

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
