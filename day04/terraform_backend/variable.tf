variable "aws_s3_bucket_name" {
  description = "The name of the S3 bucket to be created or managed."
  type        = string
  default     = "terraweek-day04-bucket-name"
}

variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type        = string
  default     = "eu-west-1"
}

variable "aws_dynamodb_table_name" {
  description = "The name of the DynamoDB table to be created or managed."
  type        = string
  default     = "terraweek-day04-table-name"
}

variable "aws_dynamodb_billing_mode" {
  description = "The billing mode for the DynamoDB table (e.g., PAY_PER_REQUEST or PROVISIONED)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "aws_dynamodb_table_haskey" {
  description = "The hash key for the DynamoDB table, used as the primary key."
  type        = string
  default     = "LockID"
}
