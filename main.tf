provider "aws" {
  region = "ap-northeast-1"
}

# VPC
resource "aws_vpc" "vpc_for_album" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc_for_album"
  }
}

# subnet
resource "aws_subnet" "album-public-subnet-1a" {
  vpc_id = aws_vpc.vpc_for_album.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "album-public-subnet-1a"
  }
}

resource "aws_subnet" "album-private-subnet-1c" {
  vpc_id = aws_vpc.vpc_for_album.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "album-private-subnet-1c"
  }
}

# gateway
resource "aws_internet_gateway" "gateway_for_album" {
  vpc_id = aws_vpc.vpc_for_album.id
  tags = {
    Name = "gateway_for_album"
  }
}

# route table
resource "aws_route_table" "table_for_album" {
  vpc_id = aws_vpc.vpc_for_album.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_for_album.id
  }
  tags = {
    Name = "table_for_album"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.album-public-subnet-1a.id
  route_table_id = aws_route_table.table_for_album.id
}

# Security group
resource "aws_security_group" "Album-SecurityGroup" {
  name = "Album-SecurityGroup"
  description = "Security for Album App"
  vpc_id = aws_vpc.vpc_for_album.id
}

# inbound rule
resource "aws_security_group_rule" "inbound_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.Album-SecurityGroup.id}"
}

resource "aws_security_group_rule" "inbound_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.Album-SecurityGroup.id}"
}

# outbound rule
resource "aws_security_group_rule" "outbound_http" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.Album-SecurityGroup.id}"
}
