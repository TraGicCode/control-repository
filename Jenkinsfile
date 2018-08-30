pipeline {
  agent { node { label 'control-repo' } }
  stages {
    stage('Syntax Check Control Repo'){
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake syntax --verbose
        ''')
      }
    }

    stage('Validate Puppetfile in Control Repo'){
      steps {
        sh(script: '''
          bundle install --path .bundle
          bundle exec rake r10k:syntax
        ''')
      }
    }

    stage("Promote To Environment"){
      steps {
        puppetCode(environment: env.BRANCH_NAME, credentialsId: 'pe-access-token')
      }
    }

    stage("Release To QA"){
      when { branch "master" }
      steps {
        puppetJob(environment: 'production', query: 'inventory[certname] { trusted.extensions.pp_environment = "staging" and nodes { deactivated is null } }', credentialsId: 'pe-access-token')
      }
    }

    stage("Release To Production"){
      when { branch "master" }
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
