variable "name" {
  description = "Choose your name"
  default     = "vpc"
}
variable "env" {
  description = "Choose your env if prod/hmg"
  default     = ""
}
variable "region" {
  description = "Choose your region"
  default     = "us-east-1"
}
variable "vpc" {
  description = "Choose your vpc"
  default     = {
    cidr_block : ""
  }
}
variable "subnets" {
  description = "Choose your subnets"
  default     = {
    public_cidr_block : []
    private_cidr_block : []
  }
}

variable "availability_zones" {
  description = "Choose your availability_zones"
  default     = []
}
variable "tags" {
  default = {
    Environment = ""
    Project     = ""
  }
}
