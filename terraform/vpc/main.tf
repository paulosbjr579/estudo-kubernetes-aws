##### VPC #####
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle { ignore_changes = [cidr_block, enable_dns_hostnames, enable_dns_support] }

  tags = {
    Name        = "${var.env}-${var.name}-vpc"
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}

##### SUBNET #####
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.subnets.public_cidr_block)
  cidr_block              = element(var.subnets.public_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  lifecycle { ignore_changes = [availability_zone, cidr_block] }

  tags = {
    Name        = "${var.env}-${var.name}-public${count.index+1}-subnet"
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.subnets.private_cidr_block)
  cidr_block              = element(var.subnets.private_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  lifecycle { ignore_changes = [availability_zone, cidr_block] }

  tags = {
    Name        = "${var.env}-${var.name}-private${count.index+1}-subnet"
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}

##### INTERNET GATEWAY #####
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name        = "${var.env}-${var.name}-igw"
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}

##### NAT GATEWAY #####
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags       = {
    Name        = "${var.env}-${var.name}-nat-eip"
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}
resource "aws_nat_gateway" "ngtw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)
  tags          = {
    Name        = "${var.env}-${var.name}-ngtw"
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# # Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngtw.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.subnets.public_cidr_block)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnets.private_cidr_block)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "${var.env}-default-sg"
  description = "Default SG to alllow traffic from the VPC ${var.name}"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = var.env
  }
}
