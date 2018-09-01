#!/usr/bin/env groovy

def merge(from, to) {
  sh('git merge ' + from + ' --ff-only')
}

def promote(Map parameters = [:]) {
  String from = parameters.from
  String to = parameters.to

  merge(from, to)

  sshagent(['control-repo-github']) {
    sh "git push origin " + to
  }
}

pipeline {
// options { skipDefaultCheckout() }
  agent { node { label 'control-repo' } }
  stages {

    stage("Promote To Development"){
      when { branch "master" }
      steps {
        // this does a checkout of the branch in the current workspace
        // According to the pipeline snippet generator this is a easier to use wrapper for the checkout step
        git url: 'https://github.com/TraGicCode/control-repository.git', branch: '*/development'
        sh('env')
        promote(from: 'master', to: 'development')
      }
    }

    stage("CodeManager Deploy Environment") {
      when { branch "master" }
      steps {
        puppetCode(environment: 'development', credentialsId: 'pe-access-token')
      }
    }

    stage("Deploy To Development"){
      when { branch "master" }
      steps {
        puppetJob(environment: 'development', query: 'inventory[certname] { trusted.extensions.pp_environment = "development" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }

  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
