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
                // string(defaultValue: '2', description: 'some extra thing', name: 'Stagger Settings', trim: false)
              ]
          if(env.DEPLOYMENT_PATTERN == 'Rolling Deployment') {
            env.STAGGER_SETTINGS = input message: 'Stagger Settings', 
            parameters: [
              string(defaultValue: '2', description: 'The stagger settings', name: 'Deploy to N Nodes at a Time', trim: false)
            ]
          }
        }


        echo env.DEPLOYMENT_PATTERN
        echo env.STAGGER_SETTINGS
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
