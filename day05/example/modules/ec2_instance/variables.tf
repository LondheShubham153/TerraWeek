variable "name" {
  description = "Logical name for this instance (used in tags)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type. On newer (post-July 2025) AWS accounts, t3.micro is the free-tier-eligible type — t2.micro is no longer accepted on the Free Plan in most regions."
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Environment this instance belongs to."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

# --- Wired in by the root module (good practice: modules take IDs, not lookups) ---

variable "ami" {
  description = "AMI ID to launch. Resolve this once in the root module via a data source and pass it in."
  type        = string

  validation {
    condition     = startswith(var.ami, "ami-")
    error_message = "ami must be a valid AMI ID starting with 'ami-'."
  }
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach to the instance."
  type        = list(string)
}

variable "tags" {
  description = "Extra tags to merge onto the instance."
  type        = map(string)
  default     = {}
}
