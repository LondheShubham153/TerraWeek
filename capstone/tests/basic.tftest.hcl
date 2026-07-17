# Mocking the AWS provider means this test suite runs in CI with zero AWS credentials —
# same principle as Day 6's test suite, just applied to real resource types this time
# instead of random_pet.
mock_provider "aws" {
  override_data {
    target = data.aws_ami.amazon_linux
    values = {
      id = "ami-0123456789abcdef0"
    }
  }
}

run "rejects_invalid_environment" {
  command = plan

  variables {
    environment      = "not-a-real-env"
    allowed_ssh_cidr = "203.0.113.10/32"
  }

  expect_failures = [var.environment]
}

run "rejects_open_ssh_cidr" {
  command = plan

  variables {
    environment      = "dev"
    allowed_ssh_cidr = "0.0.0.0/0"
  }

  expect_failures = [var.allowed_ssh_cidr]
}

run "plan_succeeds_with_valid_inputs" {
  command = plan

  variables {
    environment      = "dev"
    allowed_ssh_cidr = "203.0.113.10/32"
  }

  assert {
    condition     = var.instance_type == "t3.micro"
    error_message = "default instance type should stay free-tier-eligible t3.micro"
  }

  assert {
    condition     = anytrue([for r in aws_security_group.app_tier.ingress : r.from_port == var.app_port])
    error_message = "app tier security group must have an ingress rule opening var.app_port"
  }

  assert {
    condition     = length(aws_security_group.web_tier.ingress) == 2
    error_message = "web tier should expose exactly two ingress rules: HTTP and restricted SSH"
  }

  assert {
    condition     = !anytrue([for r in aws_security_group.app_tier.ingress : contains(coalesce(r.cidr_blocks, []), "0.0.0.0/0")])
    error_message = "app tier must never allow ingress from 0.0.0.0/0 - it should only trust the web tier's security group"
  }
}
