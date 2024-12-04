variable "name" {
  description = "Choose your name"
  default     = "openvpn"
}
variable "region" {
  description = "Choose your region"
  default     = "us-east-1"
}
variable "bucket_scripts_install" {
  description = "Bucket scripts install"
  default     = ""
}
variable "ami" {
  description = "EC2 ami"
  default     = "ami-05fa00d4c63e32376"
}
variable "instance_type" {
  description = "EC instance type"
  default     = "t3.micro"
}
variable "vpc_id" {
  default = ""
}
variable "subnet_ids" {
  default = []
}
