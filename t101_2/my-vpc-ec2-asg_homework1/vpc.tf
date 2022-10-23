provider "aws" {
  region  = "ap-northeast-3"
}

resource "aws_vpc" "lahumanvpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "t101-study"
  }
}

resource "aws_subnet" "lahumansubnet1" {
  vpc_id     = aws_vpc.lahumanvpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-3a"

  tags = {
    Name = "t101-subnet1"
  }
}

resource "aws_subnet" "lahumansubnet2" {
  vpc_id     = aws_vpc.lahumanvpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-3c"

  tags = {
    Name = "t101-subnet2"
  }
}


resource "aws_internet_gateway" "lahumanigw" {
  vpc_id = aws_vpc.lahumanvpc.id

  tags = {
    Name = "t101-igw"
  }
}

resource "aws_route_table" "lahumanrt" {
  vpc_id = aws_vpc.lahumanvpc.id

  tags = {
    Name = "t101-rt"
  }
}

resource "aws_route_table_association" "lahumanrtassociation1" {
  subnet_id      = aws_subnet.lahumansubnet1.id
  route_table_id = aws_route_table.lahumanrt.id
}

resource "aws_route_table_association" "lahumanrtassociation2" {
  subnet_id      = aws_subnet.lahumansubnet2.id
  route_table_id = aws_route_table.lahumanrt.id
}

resource "aws_route" "lahumandefaultroute" {
  route_table_id         = aws_route_table.lahumanrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lahumanigw.id
}

