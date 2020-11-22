# Infrastructure for storing tfstate files and locking mechanism

terraform {
  backend "s3" {
    bucket = "smart-test--tfstate-bucket"
    key    = "global/s3/terraform.tfstate"
    region = "eu-west-2"

    dynamodb_table = "smart-test--tfstate-locks"
    encrypt        = true
  }
}

provider "aws" {
  version = "~> 3.0"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = "smart-test--tfstate-bucket"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "tfstate-locks" {
  name         = "smart-test--tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
