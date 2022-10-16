# [과제1] EC2 웹 서버 배포

## `목표` : **Ubuntu** 에 apache(**httpd**) 를 설치하고 **index.html** 생성(**닉네임** 출력 포함)하는 **userdata** 를 짜서 설정 배포 후 curl 접속 해보고, 해당 **테라폼 코드(파일)**를 올려주세요

## 시작하기에 앞서서 

- region : 일본 오사카 사용(ap-northeast-3)
- aws ami 최신 이미지 사용
```
# data를 이용해서 최신 이미지 정보 조회
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

# amazone linux의 경우 
data "aws_ami" "linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "example" {
  ami           = "${data.aws_ami.ubuntu.id}" # 사용 예

# 매번 최신 이미지 정보를 가져오기 때문에 lifecycle를 초기 한번 가져온 이미지를 사용하도록 설정
  lifecycle {
    ignore_changes = [ami]
  }
}
```

## 제출 
```
# main.tf
provider "aws" {
  region = "ap-northeast-3" 
}


data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


resource "aws_instance" "example" {
  ami           = "${data.aws_ami.ubuntu.id}"

  lifecycle {
    ignore_changes = [ami]
  }

  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, lahuman 9090" > index.html
              nohup busybox httpd -f -p 9090 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "Single-WebSrv"
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}

output "image_id" {
    value = "${data.aws_ami.ubuntu.id}"
}
```

# [과제2] EC2 웹 서버 배포 + 웹 서버 포트 지정

## `목표` : 과제 1번 실습 구성에서 **웹 서비스 포트**를 **입력 변수 50000번**을 통해 배포 후 접속 해보고, 해당 **테라폼 코드(파일)**를 올려주세요

## 제출


### 변수 선언

```
# variables.tf
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 50000
}

```

### 변수 사용

```
# main.tf
provider "aws" {
  region = "ap-northeast-3"
}


data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


resource "aws_instance" "example" {
  ami           = "${data.aws_ami.ubuntu.id}"

  lifecycle {
    ignore_changes = [ami]
  }
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, T101 Study ${var.server_port}" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "Single-WebSrv"
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}

output "image_id" {
    value = "${data.aws_ami.ubuntu.id}"
}
```