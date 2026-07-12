output "state_bucket_name" {
  description = "Use this as the `bucket` value in your backend \"s3\" block."
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN of the state bucket."
  value       = aws_s3_bucket.state.arn
}
