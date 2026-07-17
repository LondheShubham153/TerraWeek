variable "aws_region" {
  description = "AWS region for all resources. Must match the region of the S3 state bucket."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag applied to resources. Kept simple for the capstone (single environment), unlike Day 6's multi-workspace setup."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the capstone VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to spread the public subnets across."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (one per AZ). No private subnets/NAT gateway are used, to keep this exercise free-tier-safe — tiering is enforced by security groups instead of network isolation."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for both tiers. t3.micro is free-tier-eligible on post-July-2025 AWS accounts — t2.micro is not."
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "Your IP address in CIDR form (e.g. \"203.0.113.10/32\"), allowed to SSH into the web tier. Get yours from https://checkip.amazonaws.com — never leave this as 0.0.0.0/0."
  type        = string

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "allowed_ssh_cidr must not be 0.0.0.0/0 — restrict SSH to your own IP."
  }
}

variable "app_port" {
  description = "Port the app tier listens on, reachable only from the web tier's security group."
  type        = number
  default     = 8080
}
