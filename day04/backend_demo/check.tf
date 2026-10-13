# Bonus — a check block: a continuous, non-blocking assertion that runs on
# every plan/apply. Unlike a resource, it never fails the run by itself —
# it just surfaces a warning if the condition is false, useful for catching
# drift or misconfiguration early without halting deployments.

check "app_bucket_has_name" {
  data "aws_s3_bucket" "app_data_check" {
    bucket = aws_s3_bucket.app_data.id
  }

  assert {
    condition     = data.aws_s3_bucket.app_data_check.id != ""
    error_message = "app_data bucket should exist and have a non-empty id."
  }
}
