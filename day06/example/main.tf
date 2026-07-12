# A tiny, credential-free config so `terraform test` runs anywhere.
# It builds a naming convention you can unit-test.

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "app_name" {
  description = "Application name."
  type        = string
  default     = "terraweek"
}

locals {
  # In prod we run bigger instances — demonstrates workspace/env-driven sizing.
  instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
  name_prefix   = "${var.app_name}-${var.environment}"
}

resource "random_pet" "id" {
  prefix = local.name_prefix
  length = 2
}

output "resource_name" {
  value = random_pet.id.id
}

output "instance_type" {
  value = local.instance_type
}
