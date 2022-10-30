provider "aws" {
  region = "ap-northeast-3"
}

data "aws_ami" "my_amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "example" {
  ami  = data.aws_ami.my_amazonlinux2.id
  instance_type = "t2.micro"
  tags = {
    Name = "t101-week3"
  }
}

terraform {
  backend "s3" {
    bucket = "lahuman-t101study-tfstate-week3"
    key    = "workspaces-default/terraform.tfstate"
    region = "ap-northeast-3"
    dynamodb_table = "terraform-locks-week3"
  }
}
