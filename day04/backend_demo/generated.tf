# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "terra-week-bucket-for-import"
resource "aws_s3_bucket" "imported" {
  bucket              = "terra-week-bucket-for-import"
  bucket_namespace    = "global"
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-east-1"
  tags                = {}
  tags_all            = {}
}
