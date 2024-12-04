output "master_ip" {
  value = [for instance in aws_instance.k8s_master : instance.private_ip]
}

output "worker_ips" {
  value = [for instance in aws_instance.k8s_worker : instance.private_ip]
}