variable "aws_region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally-unique name for the S3 state bucket. CHANGE THIS."
  type        = string
  default     = "terraweek-2026-state-bucket-changeme"
}
