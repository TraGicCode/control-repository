#!/usr/bin/env groovy

import groovy.json.JsonSlurperClassic

@NonCPS
def jsonSlurper(json) {
    new JsonSlurperClassic().parseText(json)
}

def createEnvironmentNodeGroup(Map parameters = [:]) {
    String environment = parameters.environment
    String parent      = parameters.parent
    String accessToken = parameters.accessToken
    String masterFqdn  = parameters.masterFqdn


    
    def response = httpRequest(
        consoleLogResponseBody: false, 
        contentType: 'APPLICATION_JSON', 
        httpMode: 'GET', 
        customHeaders: [
            [name: 'X-Authentication', value: accessToken, maskValue: true ]
        ],,
        url: "https://${masterFqdn}:4433/classifier-api/v1/groups", 
        validResponseCodes: '200')
    def jsonData = jsonSlurper(response.content)
    def parentEnvironmentGroup = jsonData.find { it.name == parent }

    httpRequest(
        consoleLogResponseBody: true, 
        contentType: 'APPLICATION_JSON', 
        httpMode: 'POST', 
        customHeaders: [
            [name: 'X-Authentication', value: accessToken, maskValue: true ]
        ],
        requestBody: """
        { 
            "name": "Jenkins Canary Environment Group",
            "parent": "${parentEnvironmentGroup.id}",
            "environment": "${environment}",
            "classes": {}
        }
        """,
        url: "https://${masterFqdn}:4433/classifier-api/v1/groups", 
        validResponseCodes: '200')
}


pipeline {
  agent { node { label 'control-repo' } }
  environment {
    PE_ACCESS_TOKEN = credentials('pe-access-token')
    PE_MASTER_FQDN  = 'puppetmaster-001.local'
    TOKEN = credentials('pe-access-token')
  }
  stages {

    stage("Test To Development"){
      when { branch "master" }
      steps {
        script {
          sh(script: 'echo \'test123!\' | puppet access login --username jenkins_puppet_deployer')
          def jobResult = sh(returnStdout: true, script: 'puppet job run --noop --format json --query "inventory[certname] { trusted.extensions.pp_environment = \'development\' and nodes { deactivated is null } }"')
          echo jobResult
        }
        // detectAffectedNodesViaNoop(masterFqdn: env.PE_MASTER_FQDN, accessToken: env.PE_ACCESS_TOKEN)
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
   }
}
