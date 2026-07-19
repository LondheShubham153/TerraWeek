# A second, real resource so `terraform state show`, `mv`, and `rm` have
# something meaningful to operate on (random_pet alone doesn't show much
# in `state show`, and `rm` on it doesn't demonstrate "infra survives").

resource "aws_s3_bucket" "app_data" {
  bucket = "terraweek-day04-appdata-${random_pet.demo.id}"

  tags = {
    Name = "terraweek-day04-app-data"
  }
}

output "app_bucket_name" {
  value = aws_s3_bucket.app_data.id
}
