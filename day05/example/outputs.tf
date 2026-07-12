output "web_public_ip" {
  description = "Public IP of the single web server."
  value       = module.web_server.public_ip
}

output "server_ips" {
  description = "Private IPs of every for_each server, keyed by name."
  value       = { for k, m in module.servers : k => m.private_ip }
}
