#!/usr/bin/groovy
def utils = new io.fabric8.Utils()

node {
  def envStage = utils.environmentNamespace('staging')
  def envProd = utils.environmentNamespace('production')

  checkout scm

  stage 'Canary release'
  if (!fileExists ('Dockerfile')) {
    writeFile file: 'Dockerfile', text: 'FROM rhscl/php-56-rhel7'
  }

  def newVersion = performCanaryRelease {}

  def rc = getrc {
    port = 80
    label = 'wordpress'
    icon = 'https://cdn.rawgit.com/fabric8io/fabric8/dc05040/website/src/images/logos/nodejs.svg'
    version = newVersion
    imageName = clusterImageName
  }

  stage 'Rolling upgrade Staging'
  kubernetesApply(file: rc, environment: envStage)

//  stage 'Approve'
//  approve{
//    room = null
//    version = canaryVersion
//    console = fabric8Console
//    environment = envStage
//  }

  stage 'Rolling upgrade Production'
  kubernetesApply(file: rc, environment: envProd)

}
