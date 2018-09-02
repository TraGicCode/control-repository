#!/usr/bin/env groovy

pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage('Syntax Check Control Repo') {
      steps {
        input message: 'Choose a Deployment Pattern', 
              parameters: [
                choice(choices: ['All Servers At Once', 'Rolling Deployment'], description: 'Pick the strategy to use for this deployment', name: ''), 
                string(defaultValue: '2', description: 'The stagger settings', name: 'Deploy to N Nodes at a Time', trim: false)
              ]

              input message: 'Stagger Settings', 
              parameters: [
                string(defaultValue: '2', description: 'The stagger settings', name: 'Deploy to N Nodes at a Time', trim: false)
              ]


        sh(script: '''
          echo 'test'
        ''')
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
