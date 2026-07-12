output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the web server."
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "Open this in your browser once the instance boots."
  value       = "http://${aws_instance.web.public_ip}"
}

output "ami_id" {
  description = "The Amazon Linux 2023 AMI resolved via the data source."
  value       = data.aws_ami.al2023.id
}
