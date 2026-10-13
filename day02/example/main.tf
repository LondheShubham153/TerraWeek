terraform {
  required_version = ">= 1.14"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Locals: compute derived values once, reuse everywhere.
locals {
  name_prefix = "tws-${var.environment}"

  common_labels = merge(
    {
      project     = "terraweek"
      environment = var.environment
      managed_by  = "terraform"
    },
    var.extra_labels,
  )

  # Bonus: for expression — transform a list
  upper_names = [for n in var.names : upper(n)]

  # Bonus: conditional expression — pick memory based on environment
  effective_memory_mb = var.environment == "prod" ? 512 : var.resource_profile.memory_mb
}

# Pull the Nginx image (tag driven by a variable).
resource "docker_image" "nginx" {
  name         = "nginx:${var.image_tag}"
  keep_locally = false
}

# Run a container from that image.
resource "docker_container" "web" {
  name  = "${local.name_prefix}-${var.container_name}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.external_port
  }

  dynamic "labels" {
    for_each = local.common_labels
    content {
      label = labels.key
      value = labels.value
    }
  }
}