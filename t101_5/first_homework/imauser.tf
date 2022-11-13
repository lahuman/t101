provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_user" "iam_users" {
  for_each = var.users
  name     = each.key
  tags     = each.value
}
