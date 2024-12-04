#!/usr/bin/env bash
set -x
yum update -y

# Install SSMAgent
https://s3.us-west-1.amazonaws.com/amazon-ssm-us-west-1/latest/linux_amd64/amazon-ssm-agent.rpm

# Install OpenVPN Server
# shellcheck disable=SC2154
aws s3 cp "s3://${bucket_scripts_install}/scripts/openvpn/openvpn_install.sh" /home/ec2-user/openvpn_install.sh
sudo chmod +x /home/ec2-user/openvpn_install.sh && export AUTO_INSTALL=y && /home/ec2-user/openvpn_install.sh && sudo rm -rf /home/ec2-user/openvpn_install.sh
aws s3 rm "s3://${bucket_scripts_install}/scripts/openvpn/openvpn_install.sh"

# Add script manager vpnuser
aws s3 cp "s3://${bucket_scripts_install}/scripts/openvpn/vpnuser.sh" /usr/local/bin/vpnuser.sh
sudo chmod +x /usr/local/bin/vpnuser.sh && sudo ln -s /usr/local/bin/vpnuser.sh /bin/vpnuser
aws s3 rm "s3://${bucket_scripts_install}/scripts/openvpn/vpnuser.sh"


