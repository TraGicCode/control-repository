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
    // for (group in jsonData) {
    //     sh("echo ${group.name}")
    // }
    sh("echo ${jsonData.find { it == parent }}")

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
            "parent": "00000000-0000-4000-8000-000000000000",
            "environment": "${environment}",
            "classes": {}
        }
        """,
        url: "https://${masterFqdn}:4433/classifier-api/v1/groups", 
        validResponseCodes: '200')
}

def createEnvironmentBranch(Map parameters = [:]) {
    String environment = parameters.environment
    sh("git checkout -b ${environment}")
    withCredentials([usernamePassword(credentialsId: '49516de6-9391-48b4-ba58-2aeb4acca97b', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
        sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/TraGicCode/control-repository HEAD')
    }
}

pipeline {
  // options { skipDefaultCheckout() }
  agent { node { label 'control-repo' } }
  environment {
    PE_ACCESS_TOKEN = credentials('pe-access-token')
    PE_MASTER_FQDN  = 'puppetmaster-001.local'
    PE_TEMP_ENVIRONMENT = "jenkins_${env.BUILD_ID}"
  }
  stages {

    stage("Promote To Development"){
      when { branch "master" }
      steps {
        createEnvironmentBranch(environment: env.PE_TEMP_ENVIRONMENT)
        createEnvironmentNodeGroup(environment: env.PE_TEMP_ENVIRONMENT, parent: 'Production Environment', accessToken: env.PE_ACCESS_TOKEN, masterFqdn: env.PE_MASTER_FQDN)
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
