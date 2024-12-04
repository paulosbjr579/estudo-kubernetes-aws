module "vpc_estudo_kubernetes" {
  source             = "./vpc"
  name               = "estudo-kubernetes"
  env                = var.env
  region             = var.region
  vpc                = local.main_vpc.vpc
  subnets            = local.main_vpc.subnets
  availability_zones = local.main_vpc.availability_zones
  tags = {
    Environment = local.tags.Environment
    Project     = local.tags.Project
  }
}