# resource "aws_instance" "k8s_master" {
#   count = length(local.k8s_ec2_main.instances)
#   ami           = local.k8s_ec2_main.instances[count.index].ami
#   instance_type = local.k8s_ec2_main.instances[count.index].instance_type
#   key_name      = local.k8s_ec2_main.instances[count.index].key_pair
#   subnet_id     = module.vpc_estudo_kubernetes.private_subnet_ids[0]
#   associate_public_ip_address = true
#
#   vpc_security_group_ids = [aws_security_group.k8s_sg.id]
#
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
#
#   tags = {
#     Name = "k8s-master${count.index + 1}-${local.k8s_ec2_main.instances[count.index].name}"
#   }
# }
#
# resource "aws_instance" "k8s_worker" {
#   count         = 2
#   ami           = local.k8s_ec2_worker.instances[count.index].ami
#   instance_type = local.k8s_ec2_worker.instances[count.index].instance_type
#   key_name      = local.k8s_ec2_worker.instances[count.index].key_pair
#   subnet_id     = module.vpc_estudo_kubernetes.private_subnet_ids[0]
#   associate_public_ip_address = true
#
#   vpc_security_group_ids = [aws_security_group.k8s_sg.id]
#
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
#
#   tags = {
#     Name = "k8s-worker-${count.index + 1}-${local.k8s_ec2_worker.instances[count.index].name}"
#   }
# }
