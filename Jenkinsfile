#!/usr/bin/groovy
def utils = new io.fabric8.Utils()

node {
  def envQA = utils.environmentNamespace('QA')
  def envStage = utils.environmentNamespace('staging')
  def envProd = utils.environmentNamespace('production')

  git 'https://github.com/Jianbo-Zhu/wordpress.git'

  stage 'Canary release'
  if (!fileExists ('wordpress/Dockerfile')) {
    writeFile file: 'wordpress/Dockerfile', text: 'FROM rhscl/php-56-rhel7'
  }

  def newVersion = getNewVersion{}

  env.setProperty('VERSION',newVersion)

  kubernetes.image().withName("${env.FABRIC8_DOCKER_REGISTRY_SERVICE_HOST}:${env.FABRIC8_DOCKER_REGISTRY_SERVICE_PORT}/${env.KUBERNETES_NAMESPACE}/${env.JOB_NAME}").build().fromPath(".")
  kubernetes.image().withName("${env.FABRIC8_DOCKER_REGISTRY_SERVICE_HOST}:${env.FABRIC8_DOCKER_REGISTRY_SERVICE_PORT}/${env.KUBERNETES_NAMESPACE}/${env.JOB_NAME}").push().toRegistry()

  def rc = getrc {
    port = 80
    label = 'shiftworkweb'
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
