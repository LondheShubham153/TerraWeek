variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Second region used only by the aliased 'dr' provider (bonus task)."
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type. On newer AWS accounts, t3.micro is free-tier-eligible."
  type        = string
  default     = "t3.small"
}

variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
  default     = "terraweek"
}

# --- Meta-argument demo variables (Task 4) ---

variable "extra_worker_count" {
  description = "How many identical extra EC2 instances to create with count."
  type        = number
  default     = 2
}

variable "private_subnets" {
  description = "Map of named private subnets (key = name, value = CIDR) — used with for_each."
  type        = map(string)
  default = {
    "app" = "10.0.2.0/24"
    "db"  = "10.0.3.0/24"
  }
}
