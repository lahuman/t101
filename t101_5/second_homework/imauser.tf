provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_user" "iam_users" {
  for_each = toset(var.users)
  name     = each.value
  tags     = { group : split("_", each.value)[0] }
}
