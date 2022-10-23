terraform {
  backend "s3" {
    bucket = "lahuman-t101study-tfstate"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-3"
    dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}
