output "vpc_id" {
  description = "ID of the capstone VPC."
  value       = module.vpc.vpc_id
}

output "web_public_ip" {
  description = "Public IP of the web tier instance — this is what you'll SSH into / curl."
  value       = module.web_server.public_ip
}

output "app_public_ip" {
  description = "Public IP of the app tier instance. Reachable at the network level, but its security group only accepts traffic from the web tier's SG — not from the internet."
  value       = module.app_server.public_ip
}

output "web_instance_id" {
  description = "Instance ID of the web tier."
  value       = module.web_server.instance_id
}

output "app_instance_id" {
  description = "Instance ID of the app tier."
  value       = module.app_server.instance_id
}
