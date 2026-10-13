# Module: `ec2_instance`

A minimal, reusable EC2 instance module. It takes network + AMI **IDs as inputs**
(resolved once in the root module) and applies a consistent tagging scheme —
so it stays reusable across VPCs, regions, and accounts.

## Usage

```hcl
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

module "web_server" {
  source                 = "./modules/ec2_instance"
  name                   = "web"
  instance_type          = "t3.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id
  subnet_id              = "subnet-0123456789abcdef0"
  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  tags = {
    Owner = "your-name"
  }
}
```

## Inputs

| Name                     | Description                              | Type           | Default    | Required |
|--------------------------|------------------------------------------|----------------|------------|:--------:|
| `name`                   | Logical name (used in tags)              | `string`       | —          |   yes    |
| `ami`                    | AMI ID to launch (must start `ami-`)     | `string`       | —          |   yes    |
| `subnet_id`              | Subnet to launch the instance in         | `string`       | —          |   yes    |
| `vpc_security_group_ids` | Security group IDs to attach             | `list(string)` | —          |   yes    |
| `instance_type`          | EC2 instance type (Free Tier: t3.micro on newer accounts) | `string` | `t3.micro` | no |
| `environment`            | One of `dev` / `staging` / `prod`        | `string`       | `dev`      |    no    |
| `tags`                   | Extra tags merged onto the instance      | `map(string)`  | `{}`       |    no    |

## Outputs

| Name          | Description                     |
|---------------|---------------------------------|
| `instance_id` | ID of the created instance      |
| `public_ip`   | Public IP of the instance       |
| `private_ip`  | Private IP of the instance      |
