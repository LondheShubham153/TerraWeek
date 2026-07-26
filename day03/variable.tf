# AMI owner ID for the AWS account (default: Canonical for Ubuntu images)
variable "aws_ami_owners" {
    description = "AWS account ID of the AMI owner"
    type        = string
    default     = "099720109477"
}

# AWS region where the EC2 instance will be launched
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

# AMI filter pattern for the desired Ubuntu image
variable "aws_ami_image" {
    description = "Filter pattern for the desired AWS AMI (Ubuntu)"
    type        = string
    default     = "ubuntu/images/hvm-ssd/*amd64*"
}

# Path to the private key file for SSH access
variable "aws_private_key_pair_name" {
    description = "Path to the private key pair for SSH"
    type        = string
    default     = "~/terraweek-key"
}

# Path to the public key file for SSH access
variable "aws_public_key_pair_name" {
    description = "Path to the public key pair for SSH"
    type        = string
    default     = "terraweek-key.pub"
}

# Name of the security group to be created
variable "aws_sg_name" {
    description = "Name of the security group"
    type        = string
    default     = "my_terraweek_sg"
}

# Description of the security group
variable "aws_sg_description" {
    description = "Description of the security group"
    type        = string
    default     = "Allow TLS inbound traffic and all outbound traffic"
}

# Protocol used for SSH access (default: TCP)
variable "ssh_protocol" {
    description = "Protocol for SSH traffic"
    type        = string
    default     = "tcp"
}

# CIDR block for SSH access (default: allow all)
variable "ssh_cidr" {
    description = "CIDR block for SSH access"
    type        = string
    default     = "0.0.0.0/0"
}

# Protocol used for HTTP traffic (default: TCP)
variable "http_protocol" {
    description = "Protocol for HTTP traffic"
    type        = string
    default     = "tcp"
}

# CIDR block for HTTP access (default: allow all)
variable "http_cidr" {
    description = "CIDR block for HTTP access"
    type        = string
    default     = "0.0.0.0/0"
}

# Protocol used for HTTPS traffic (default: TCP)
variable "https_protocol" {
    description = "Protocol for HTTPS traffic"
    type        = string
    default     = "tcp"
}

# CIDR block for HTTPS access (default: allow all)
variable "https_cidr" {
    description = "CIDR block for HTTPS access"
    type        = string
    default     = "0.0.0.0/0"
}

# Protocol used for outgoing traffic (default: all)
variable "outgoing_protocol" {
    description = "Protocol for outgoing traffic"
    type        = string
    default     = "-1"
}

# CIDR block for outgoing traffic (IPv4)
variable "outgoing_cidr" {
    description = "CIDR block for outgoing IPv4 traffic"
    type        = string
    default     = "0.0.0.0/0"
}

# CIDR block for outgoing traffic (IPv6)
variable "outgoing_ipv6_cidr" {
    description = "CIDR block for outgoing IPv6 traffic"
    type        = string
    default     = "::/0"
}

# Instance type for the AWS EC2 instance (default: t2.micro)
variable "aws_instance_type" {
    description = "Type of EC2 instance to be launched"
    type        = string
    default     = "t2.micro"
}

# Size of the root volume for the EC2 instance in GB
variable "aws_instance_volume_size" {
    description = "Size of the root volume in GB"
    type        = number
    default     = 10
}

# Type of the root volume for the EC2 instance (default: gp3)
variable "aws_instance_volume_type" {
    description = "Type of the root volume (e.g., gp3, gp2, io1)"
    type        = string
    default     = "gp3"
}

# Name tag for the AWS EC2 instance
variable "aws_instance_name" {
    description = "Name tag for the EC2 instance"
    type        = string
    default     = "Terraweek-Day-03"
}
