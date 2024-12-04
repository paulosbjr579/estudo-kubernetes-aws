terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }

  backend "s3" {
    bucket  = "tf-estudo-kubernets"
    key     = "application/application.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
