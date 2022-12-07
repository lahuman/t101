provider "aws" {
  region = "us-east-2" 
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lahuman-study"
  }
}
resource "aws_subnet" "mysubnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "us-east-2a"

  tags = {
    Name = "lahuman-subnet1"
  }
}

resource "aws_subnet" "mysubnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "us-east-2c"

  tags = {
    Name = "lahuman-subnet2"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "lahuman-igw"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "lahuman-rt"
  }
}

resource "aws_route_table_association" "myrtassociation1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "myrtassociation2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route" "mydefaultroute" {
  route_table_id         = aws_route_table.myrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}
