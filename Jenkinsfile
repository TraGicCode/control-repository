#!/usr/bin/env groovy

pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage('Deploy to development') {
      steps {
        script {
          env.DEPLOYMENT_PATTERN = input message: 'Choose a Deployment Pattern', 
              parameters: [
                choice(choices: ['All Servers At Once', 'Rolling Deployment'], description: 'Pick the strategy to use for this deployment', name: 'Deployment Pattern'),
              ]
          if(env.DEPLOYMENT_PATTERN == 'Rolling Deployment') {
            env.STAGGER_SETTINGS = input message: 'Stagger Settings', 
            parameters: [
              string(defaultValue: '2', description: '# of nodes to deploy to concurrently', name: 'Deploy to N Node(s) at a Time', trim: false),
              string(defaultValue: '60', description: '# of seconds to wait once beforing continuing to the rest of the nodes', name: 'Wait N seconds between deploys', trim: false)
            ]
          }
          echo env.STAGGER_SETTINGS
          development_nodes = puppet.query 'inventory[certname] { trusted.extensions.pp_environment = "development" and nodes { deactivated is null } }', credentials: 'pe-access-token'
          certnames = []
          for (Map node : development_nodes) {
            certnames.add(node.certname) //Extract the certnames from the query results
          }
          phase_groups = certnames.collate(env.STAGGER_SETTINGS['Deploy to N Node(s) at a Time']) //Break node list into groups of N
          for (ArrayList phase_nodes : phase_groups) {
            puppet.job 'production', nodes: phase_nodes //Run Puppet on each sub group
            input 'Ready to continue?' //Pause the deployment between phases for review
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
