resource "aws_instance" "openvpn" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.openvpn_security_group.id]
  subnet_id                   = var.subnet_ids[0]
  iam_instance_profile        = aws_iam_instance_profile.openvpn_instance_profile.name
  user_data                   = data.template_file.initial_install.rendered

  depends_on = [aws_iam_instance_profile.openvpn_instance_profile, aws_security_group.openvpn_security_group]

  tags = {
    Name = "Openvpn-Server"
  }
}

data "template_file" "initial_install" {
  template = file("vpn/initial_install.sh")
  vars     = {
    region_name            = var.region
    bucket_scripts_install = var.bucket_scripts_install
  }
}
resource "aws_s3_object" "scripts_openvpn_install_s3" {
  bucket = var.bucket_scripts_install
  key    = "scripts/openvpn/openvpn_install.sh"
  source = "vpn/openvpn_install.sh"
}
resource "aws_s3_object" "scripts_vpnuser_s3" {
  bucket = var.bucket_scripts_install
  key    = "scripts/openvpn/vpnuser.sh"
  source = "vpn/vpnuser.sh"
}

resource "aws_iam_instance_profile" "openvpn_instance_profile" {
  name = "${var.name}-profile"
  role = aws_iam_role.openvpn_role.name
}
resource "aws_iam_role" "openvpn_role" {
  name               = "${var.name}-role"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "openvpn_ssm_policy" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "openvpn_s3_policy" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_security_group" "openvpn_security_group" {
  name        = "${var.name}-server-sg"
  description = "Allow all traffic OpenVPN Server"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TCP OpenVPN Port"
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow UDP OpenVPN Port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-server-sg"
  }
}
