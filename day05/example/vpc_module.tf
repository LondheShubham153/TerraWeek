# Task 4 — Consume a real Terraform Registry module + pin its version.
#
# This uses HashiCorp Registry's most popular community module,
# terraform-aws-modules/vpc/aws, to build a small VPC — separate from the
# default VPC used above, just to demonstrate registry consumption.
#
# ⚠️ Cost note: NAT gateways cost ~$0.045/hr + data charges and are NOT
# free-tier eligible. This config deliberately sets
# enable_nat_gateway = false to keep this exercise free. Don't flip that
# to true unless you're fine with the charge.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0" # pinned — registry modules should always be version-locked

  name = "terraweek-day05-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a"]
  public_subnets  = ["10.1.1.0/24"]
  private_subnets = ["10.1.2.0/24"]

  enable_nat_gateway = false # keep this false to stay free-tier friendly
  enable_vpn_gateway = false

  tags = {
    Day = "05"
  }
}

output "registry_vpc_id" {
  description = "ID of the VPC built by the registry module."
  value       = module.vpc.vpc_id
}

output "registry_vpc_public_subnets" {
  value = module.vpc.public_subnets
}
