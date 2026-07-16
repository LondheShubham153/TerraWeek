# Reusable EC2 module.
#
# Note how this module takes IDs (ami, subnet_id, security groups) as INPUTS
# rather than looking them up itself. That's a deliberate best practice:
#   - the module stays reusable across VPCs, regions, and accounts
#   - data-source lookups happen ONCE in the root module (not per instance)
#   - callers can wire it to their own network (e.g. the VPC you built on Day 3)

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  tags = merge(
    {
      Name        = "${var.environment}-${var.name}"
      Environment = var.environment
      Module      = "ec2_instance"
    },
    var.tags,
  )
  root_block_device {
    encrypted = true
  }
}
