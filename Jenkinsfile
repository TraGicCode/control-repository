#!/usr/bin/env groovy

pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage('Check for trashy commits') {
      steps {
         sh(script: '''
          bundle install --path .bundle
          bundle exec rake check:dot_underscore
          bundle exec rake check:git_ignore
          bundle exec rake check:symlinks
          bundle exec rake check:test_file
        ''')
      }
    }
    stage('Syntax Check ( PuppetFile )') {
      steps {
        // input(message: 'Choose a Deployment Pattern',    
        //       parameters: [
        //         choice(name: 'Deployment Pattern', choices: "All Servers At Once\nRolling Deployment")
        //       ])
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake r10k:syntax
        ''')
      }
    }

    stage('Syntax Check ( Manifests/Templates/Hiera )') {
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake syntax --verbose
        ''')
      }
    }

    stage('Puppet Lint') {
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake lint
        ''')
      }
    }

    stage('Rubocop'){
      steps {
        sh(script: '''
          bundle exec rake rubocop
        ''')
      }
    }

    stage('Unit Tests'){
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake spec_prep
          bundle exec rake spec_standalone
        ''')
      }
      post {
        always {
          junit '.tmp/rspec_puppet.xml'
        }
      }
    }

    stage("CodeManager Deploy Environment") {
      when { branch "production" }
      steps {
        puppetCode(environment: env.BRANCH_NAME, credentialsId: 'pe-access-token')
      }
    }

    stage("Deploy To Development"){
      when { branch "production" }
      steps {
        puppetJob(environment: 'production', query: 'inventory[certname] { trusted.extensions.pp_environment = "development" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }

    stage("Deploy To Staging"){
      when { branch "production" }
      steps {
        input 'Ready to release to Staging?'
        puppetJob(environment: 'production', query: 'inventory[certname] { trusted.extensions.pp_environment = "staging" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }

    stage("Deploy To Production"){
      when { branch "production" }
      steps {
        input 'Ready to release to Production?'
        puppetJob(environment: 'production', query: 'inventory[certname] { trusted.extensions.pp_environment = "production" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
