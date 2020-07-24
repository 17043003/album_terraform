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
