# Output for Public IP Address of the EC2 Instance
output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

# Output for Private IP Address of the EC2 Instance
output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.my_instance.private_ip
}
