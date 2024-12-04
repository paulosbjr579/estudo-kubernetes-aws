output "vpc_name" {
  value = aws_vpc.vpc.default_network_acl_id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}
output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}
output "default_security_groups_ids" {
  value = aws_security_group.default.id
}
output "public_route_table_id" {
  value = aws_route_table.public.id
}
output "private_route_table_id" {
  value = aws_route_table.private.id
}
# output "nat_eip" {
#   value = aws_eip.nat_eip.public_ip
# }
