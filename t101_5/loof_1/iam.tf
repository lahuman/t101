provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_user" "myiam" {
  count = 3
  name  = "lahuman.${count.index}"
}
