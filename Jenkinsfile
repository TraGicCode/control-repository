#!/usr/bin/env groovy

pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage("Deploy To Development"){
      // when { branch "production" }
      steps {
        script {
            // Get all of the classes that have changed
            changedClasses    = sh(returnStdout: true, script: './scripts/get_changed_classes.rb').trim().split('\n')
            // Get the number of classes that have changed
            numChangedClasses = sh(returnStdout: true, script: './scripts/count_changed_classes.rb').trim().toInteger()
            // Generate a query that we will use
            nodeQuery         = ('nodes { resources { type = "Class" and title in ' + ("[\"" + changedClasses.join("\",\"") + "\"]") + ' } and catalog_environment = "' + env.BRANCH_NAME +'" }').toString()
            // If things have changed then execute the query
            if (numChangedClasses > 0) {
            echo nodeQuery
            affectedNodes  = puppet.query nodeQuery
            // If nothing has been affected by the change we don't need to try to
            // initiate the run
            if (affectedNodes.size() > 0) {
                puppet.job env.BRANCH_NAME, query: nodeQuery
            } else {
                echo "Classes: " + changedClasses.join(",") + " changed. But no nodes were affected, skipping run."
            }
            } else {
                echo "No classes changed, skipping this step."
            }
        }
        puppetJob(environment: 'production', query: 'inventory[certname] { trusted.extensions.pp_environment = "development" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
