#!/usr/bin/env groovy

pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage('Deploy to development') {
      steps {
        script {
          def deploymentPattern = input message: 'Choose a Deployment Pattern', 
              parameters: [
                choice(choices: ['All Servers At Once', 'Rolling Deployment'], description: 'Pick the strategy to use for this deployment', name: 'Deployment Pattern'),
              ]
          if(deploymentPattern == 'Rolling Deployment') {
            def staggerSettings = input message: 'Stagger Settings', 
            parameters: [
              // Deploy to N Node(s) at a Time
              string(defaultValue: '2', description: '# of nodes to deploy to concurrently', name: 'Stagger Count', trim: false),
              string(defaultValue: '60', description: '# of seconds to wait once beforing continuing to the rest of the nodes', name: 'Wait N seconds between deploys', trim: false)
            ]

            echo staggerSettings['Stagger Count']
            development_nodes = puppet.query 'inventory[certname] { trusted.extensions.pp_environment = "development" and nodes { deactivated is null } }', credentials: 'pe-access-token'
            certnames = []
            for (Map node : development_nodes) {
              certnames.add(node.certname) //Extract the certnames from the query results
            }
            phase_groups = certnames.collate(staggerSettings['Stagger Count'] as Integer) //Break node list into groups of N
            for (ArrayList phase_nodes : phase_groups) {
              puppetJob(environment: 'production', nodes: phase_nodes, credentialsId: 'pe-access-token') //Run Puppet on each sub group
              sleep(time: staggerSettings['Wait N seconds between deploys'] as Integer, unit: 'SECONDS')
            }
          }
        }

      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
