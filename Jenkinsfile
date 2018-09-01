#!/usr/bin/env groovy

def merge(from, to) {
  sh('git merge ' + from + ' --ff-only')
}

def promote(Map parameters = [:]) {
  String from = parameters.from
  String to = parameters.to

  merge(from, to)

  withCredentials([usernamePassword(credentialsId: '49516de6-9391-48b4-ba58-2aeb4acca97b', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
    sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/TraGicCode/control-repository HEAD')
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
        git url: 'https://github.com/TraGicCode/control-repository.git', branch: 'development'
        sh('env')
        promote(from: '${GIT_COMMIT}', to: 'development')
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
