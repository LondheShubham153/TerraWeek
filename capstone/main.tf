# TerraWeek Capstone — 2-tier web app
#
# Design notes (documented trade-offs, not oversights):
# - Public-subnet-only, no NAT gateway: keeps this exercise free-tier-safe. Tiering is
#   enforced by security groups rather than network isolation — the app tier's SG only
#   accepts traffic from the web tier's SG, never from 0.0.0.0/0, even though both
#   instances technically sit in public subnets.
# - The ec2_instance module (v1.1.0) doesn't expose a way to disable public IP assignment
#   per-instance — that's controlled at the subnet level. Since we're not using NAT/private
#   subnets, both instances get a public IP by default; the app tier's protection comes
#   entirely from its restrictive security group, not from lacking a public IP. Documented
#   here the same way Day 6 documented the VPC Flow Logs trade-off — a conscious choice,
#   not a gap.

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "terraweek-capstone-vpc"
  cidr = var.vpc_cidr

  azs            = var.availability_zones
  public_subnets = var.public_subnet_cidrs

  map_public_ip_on_launch = true # without this, instances in "public" subnets get no public IP at all

  enable_nat_gateway   = false # documented trade-off — see file header
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project     = "terraweek-capstone"
    Environment = var.environment
  }
}

resource "aws_security_group" "web_tier" {
  name        = "capstone-web-tier-sg"
  description = "Web tier - HTTP from the internet, SSH from the operator IP only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from operator IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "HTTPS outbound - package updates, AWS API calls"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound - some package repos still redirect through 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_tier" {
  name        = "capstone-app-tier-sg"
  description = "App tier - reachable only from the web tier, never from the internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "App port from web tier only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }

  ingress {
    description     = "SSH from web tier only (hop through the web instance, no direct SSH ingress)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }

  egress {
    description = "HTTPS outbound - package updates, AWS API calls"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound - some package repos still redirect through 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "capstone-app-tier-sg"
    Environment = var.environment
  }
}

# --- Tier 1: web ---------------------------------------------------------
module "web_server" {
  source = "git::https://github.com/saadhussain07/terraform-ec2-module.git?ref=v1.1.0"

  name                   = "capstone-web"
  environment            = var.environment
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.web_tier.id]

  tags = {
    Tier = "web"
  }
}

# --- Tier 2: app (the capstone's "backend") -------------------------------
module "app_server" {
  source = "git::https://github.com/saadhussain07/terraform-ec2-module.git?ref=v1.1.0"

  name                   = "capstone-app"
  environment            = var.environment
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[1]
  vpc_security_group_ids = [aws_security_group.app_tier.id]

  tags = {
    Tier = "app"
  }
}
