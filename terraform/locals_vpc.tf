locals {
  main_vpc = {
    vpc = {
      cidr_block = "10.10.0.0/16"
    }
    subnets = {
      private_cidr_block = [
        "10.10.1.0/24", "10.10.5.0/24"
      ]
      public_cidr_block = [
        "10.10.10.0/24", "10.10.15.0/24"
      ]
    }
    availability_zones  = ["${var.region}a", "${var.region}b"]
  }
}
