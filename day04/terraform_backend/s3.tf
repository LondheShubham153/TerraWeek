resource "aws_s3_bucket" "my_bucket" {
  bucket = var.aws_s3_bucket_name

  tags = {
    Name = var.aws_s3_bucket_name
  }
}