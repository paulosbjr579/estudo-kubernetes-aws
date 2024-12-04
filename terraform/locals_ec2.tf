locals {
  k8s_ec2_main = {
    instances = [
      {
        name = "principal"
        ami = "ami-0866a3c8686eaeeba"
        instance_type = "t2.medium"
        key_pair = "k8s-key"
      }
    ]
  }
  k8s_ec2_worker = {
    instances= [
      {
        name = "app-teste-a"
        ami = "ami-0866a3c8686eaeeba"
        instance_type = "t2.medium"
        key_pair = "k8s-key"
      },
      {
        name = "app-teste-b"
        ami = "ami-0866a3c8686eaeeba"
        instance_type = "t2.medium"
        key_pair = "k8s-key"
      }
    ]
  }
}
