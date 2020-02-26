variable "account_id" {}
variable "bucket_name" {}
variable "provisioner_role" {
  default = "TF_ADMIN"
}
variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.provisioner_role}"
  }
}

resource "aws_s3_bucket" "replica" {
  bucket = var.bucket_name
  region = var.region
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

output "replica_bucket_arn" {
  value = aws_s3_bucket.replica.arn
}
