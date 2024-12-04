output "openvpn_public_id" {
  value = aws_instance.openvpn.public_ip
}
output "openvpn_public_dns" {
  value = aws_instance.openvpn.public_dns
}
