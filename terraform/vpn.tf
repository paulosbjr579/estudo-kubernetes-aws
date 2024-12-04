module "openvpn" {
  source                 = "./vpn"
  name                   = "openvpn"
  region                 = var.region
  ami                    = "ami-05fa00d4c63e32376" # Amazon Linux 2 latest version
  instance_type          = "t3.micro"
  bucket_scripts_install = "tf-estudo-kubernets" # Mesmo bucket usado para armazenar os script do terraform
  vpc_id                 = module.vpc_estudo_kubernetes.vpc_id # Pode ser substituido por id de uma VPC existente, caso não for utilizar o provisionamento da VPC
  subnet_ids             = module.vpc_estudo_kubernetes.public_subnet_ids # Pode ser substituido por ids de subnets publicas existente, caso não for utilizar o provisionamento da VPC
  depends_on             = [module.vpc_estudo_kubernetes] # Opcional caso não for utilizar o provisionamento da VPC
}
