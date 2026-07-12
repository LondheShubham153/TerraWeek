output "container_name" {
  description = "Full name of the running container."
  value       = docker_container.web.name
}

output "access_url" {
  description = "URL to reach the Nginx welcome page."
  value       = format("http://localhost:%d", var.external_port)
}

output "image" {
  description = "The image the container is running."
  value       = docker_image.nginx.name
}
