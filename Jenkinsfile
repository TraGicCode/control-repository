def merge(from, to) {
  sh('git checkout ' + to)
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


    stage("Promote To Development"){
      when { branch "master" }
      steps {
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
