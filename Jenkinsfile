#!/usr/bin/groovy
def utils = new io.fabric8.Utils()

node {
  def envQA = utils.environmentNamespace('QA')
  def envStage = utils.environmentNamespace('staging')
  def envProd = utils.environmentNamespace('production')

  checkout scm

  stage 'Canary release'
  if (!fileExists ('Dockerfile')) {
    writeFile file: 'Dockerfile', text: 'FROM rhscl/php-56-rhel7'
  }

  def newVersion = getNewVersion{}

  env.setProperty('VERSION',newVersion)

  kubernetes.image().withName("${env.JOB_NAME}").build().fromPath(".")
  kubernetes.image().withName("${env.JOB_NAME}").tag().inRepository("${env.FABRIC8_DOCKER_REGISTRY_SERVICE_HOST}:${env.FABRIC8_DOCKER_REGISTRY_SERVICE_PORT}/${env.KUBERNETES_NAMESPACE}/${env.JOB_NAME}").withTag(newVersion)
  kubernetes.image().withName("${env.FABRIC8_DOCKER_REGISTRY_SERVICE_HOST}:${env.FABRIC8_DOCKER_REGISTRY_SERVICE_PORT}/${env.KUBERNETES_NAMESPACE}/${env.JOB_NAME}").push().withTag(newVersion).toRegistry()

  def rc = getrc {
    port = 80
    label = 'wordpress'
    icon = 'https://cdn.rawgit.com/fabric8io/fabric8/dc05040/website/src/images/logos/nodejs.svg'
    version = newVersion
    imageName = clusterImageName
  }

  stage 'Rolling upgrade Staging'
  kubernetesApply(file: rc, environment: envStage)

  stage 'Approve'
  approve{
    room = null
    version = canaryVersion
    console = fabric8Console
    environment = envStage
  }

  stage 'Rolling upgrade Production'
  kubernetesApply(file: rc, environment: envProd)

}
