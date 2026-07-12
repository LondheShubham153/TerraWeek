# Native Terraform tests (Terraform 1.6+). Run with:  terraform test
# Each `run` block executes plan or apply and asserts on the result.

# 1) Default (dev) should pick the small instance type. Plan-only, no apply.
run "dev_uses_micro" {
  command = plan

  assert {
    condition     = local.instance_type == "t3.micro"
    error_message = "dev environment should use t3.micro"
  }
}

# 2) prod should scale up to a larger instance type.
run "prod_uses_medium" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = local.instance_type == "t3.medium"
    error_message = "prod environment should use t3.medium"
  }
}

# 3) Full apply: the generated name should start with our prefix.
run "name_has_prefix" {
  command = apply

  variables {
    environment = "staging"
    app_name    = "tws"
  }

  assert {
    condition     = startswith(output.resource_name, "tws-staging")
    error_message = "resource name must start with the app-environment prefix"
  }
}

# 4) Invalid environment must be rejected by the variable validation.
run "rejects_bad_environment" {
  command = plan

  variables {
    environment = "banana"
  }

  expect_failures = [var.environment]
}
