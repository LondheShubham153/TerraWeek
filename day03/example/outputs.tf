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

# --- Meta-argument outputs ---

output "worker_instance_ids" {
  description = "IDs of the extra EC2 instances created via count."
  value       = aws_instance.worker[*].id
}

output "private_subnet_ids" {
  description = "IDs of the named private subnets created via for_each."
  value       = { for name, subnet in aws_subnet.private : name => subnet.id }
}

output "protected_bucket_name" {
  description = "Name of the S3 bucket protected by lifecycle.prevent_destroy."
  value       = aws_s3_bucket.protected_demo.bucket
}
