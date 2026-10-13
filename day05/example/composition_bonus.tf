# # Bonus — module composition: pass one module's output as another module's
# # input. Here, the registry vpc module's public subnet + default security
# # group would feed straight into our own ec2_instance module.
# #
# # Left commented out by default — uncommenting adds one more real EC2
# # instance (small cost, but non-zero). Uncomment only if you want to see
# # this in action.

# module "vpc_demo_server" {
#   source                 = "./modules/ec2_instance"
#   name                   = "vpc-demo"
#   instance_type          = "t3.micro"
#   environment            = "dev"
#   ami                    = data.aws_ami.al2023.id
#   subnet_id              = module.vpc.public_subnets[0]
#   vpc_security_group_ids = local.security_group_ids
# }

# output "vpc_demo_server_ip" {
#   value = module.vpc_demo_server.public_ip
# }
