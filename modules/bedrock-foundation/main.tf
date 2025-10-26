resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

data "aws_caller_identity" "current" {}