# Task 5 — import an existing resource.
#
# 1. Manually create an S3 bucket in the AWS Console (any unique name),
#    e.g. "your-name-manual-bucket-2026".
# 2. Uncomment the block below and set the id to that exact bucket name.
# 3. Run:
#      terraform plan -generate-config-out=generated.tf
#    This writes a best-guess resource block into generated.tf — review
#    it, then run `terraform apply` to bring it under management.

import {
  to = aws_s3_bucket.imported
  id = "terra-week-bucket-for-import"
}
