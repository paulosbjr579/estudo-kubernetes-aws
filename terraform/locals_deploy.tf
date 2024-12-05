locals {
  app_teste = {
    name                = "app_teste"
    repository          = "teste4071949/kubernetes-aws-provission"
    repositoryEcr       = "app-teste"
    region              = "us-east-1"
    environment         = "latest"
    branch              = "main"
    buildspec           = "buildspec.yml"
    fileName            = "imagedefinitions.json"
  }
}
