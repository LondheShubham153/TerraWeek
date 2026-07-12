# The S3 bucket that will store Terraform state for other configs.
# With Terraform 1.11+ native locking (use_lockfile), NO DynamoDB table is needed.

resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name

  tags = {
    Name = var.state_bucket_name
  }
}

# Keep a history of state files so you can recover from mistakes.
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt state at rest (state can contain secrets in plaintext).
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the state bucket.
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
