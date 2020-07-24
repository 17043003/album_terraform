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
