# --- Primitive types ---

variable "container_name" {
  description = "Name of the Docker container."
  type        = string
  default     = "terraweek-web"
}

variable "external_port" {
  description = "Host port to expose the container on."
  type        = number
  default     = 8080

  validation {
    condition     = var.external_port > 1024 && var.external_port < 65535
    error_message = "external_port must be between 1025 and 65534."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

# --- Sensitive value ---

variable "registry_token" {
  description = "Example sensitive value — not used by Docker Hub's public pulls, shown for the pattern."
  type        = string
  default     = "dummy-token"
  sensitive   = true
}

# --- Collection types ---

variable "image_tag" {
  description = "Nginx image tag to pull."
  type        = string
  default     = "1.27-alpine"
}

variable "extra_labels" {
  description = "Additional labels to attach to the container."
  type        = map(string)
  default = {
    team = "trainwithshubham"
  }
}

variable "names" {
  description = "List of names used to demonstrate a for expression."
  type        = list(string)
  default     = ["shubham", "terraweek", "tws"]
}

# --- Structural type, with an optional() attribute (bonus) ---

variable "resource_profile" {
  description = "Resource sizing profile. 'notes' is optional and defaults to null if not set."
  type = object({
    cpu_shares = number
    memory_mb  = number
    notes      = optional(string)
  })
  default = {
    cpu_shares = 512
    memory_mb  = 256
    notes      = null
  }
}