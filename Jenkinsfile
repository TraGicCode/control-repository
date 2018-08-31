pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage('Syntax Check Control Repo') {
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake syntax --verbose
        ''')
      }
    }

    stage('Validate Puppetfile In Control Repo') {
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake r10k:syntax
        ''')
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
        input 'Ready to release to Production?'
        puppetJob(environment: 'production', query: 'inventory[certname] { trusted.extensions.pp_environment = "staging" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }

    stage("Deploy To Production"){
      when { branch "production" }
      steps {
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
