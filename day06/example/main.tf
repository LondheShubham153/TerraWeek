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
  description = "Applilcation name."
  type        = string
  default     = "terraweek"
}

locals {
  # In prod we run bigger instances — demonstrates workspace/env-driven sizing.
  instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
  name_prefix   = "${var.app_name}-${var.environment}"

  # Task 1 also asks for terraform.workspace directly in config — shown here
  # as a second, independent sizing rule so both approaches are visible side
  # by side. Note this reflects the CLI workspace (`terraform workspace select`),
  # which is separate from the `environment` variable above.
  workspace_instance_type = terraform.workspace == "prod" ? "t3.medium" : "t3.micro"
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

output "current_workspace" {
  description = "Which CLI workspace this run executed in."
  value       = terraform.workspace
}

output "workspace_instance_type" {
  description = "Instance size if driven by terraform.workspace instead of var.environment."
  value       = local.workspace_instance_type
}
