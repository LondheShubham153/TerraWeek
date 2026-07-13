output "container_name" {
  value = docker_container.web.name
}

output "container_url" {
  value = "http://localhost:${var.external_port}"
}

output "name_prefix" {
  value = local.name_prefix
}

output "common_labels" {
  value = local.common_labels
}

output "upper_names" {
  value = local.upper_names
}

output "effective_memory_mb" {
  value = local.effective_memory_mb
}