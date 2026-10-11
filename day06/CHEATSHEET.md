# 🚀 Day 6 Cheat Sheet: Advanced Terraform

Quick reference for [Day 6](./README.md).

---

## 🗂️ Workspaces

```bash
terraform workspace list
terraform workspace new staging
terraform workspace select staging
terraform workspace show
```

```hcl
instance_type = terraform.workspace == "prod" ? "t3.medium" : "t3.micro"
```

## 🧪 Native Tests (`terraform test`)

```hcl
# tests/basic.tftest.hcl
run "bucket_name_is_valid" {
  command = plan

  assert {
    condition     = startswith(aws_s3_bucket.demo.bucket, "tws-")
    error_message = "Bucket name must start with tws-"
  }
}
```

```bash
terraform init
terraform test
```

## 🧹 Quality Gates

```bash
terraform fmt -recursive -check   # formatting
terraform validate                # syntax and types
terraform test                    # your tests
trivy config .                    # security scan (or: checkov -d .)
tflint                            # linting
```

## 🤖 CI/CD (GitHub Actions)

```yaml
- uses: hashicorp/setup-terraform@v3
- run: terraform fmt -check
- run: terraform init
- run: terraform validate
- run: terraform plan
```

## 🔒 Secrets & Safety

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

- Never hard-code secrets or commit `*.tfstate` / `*.tfvars`.
- Use env vars (`TF_VAR_*`) or a secrets manager.
- Pin Terraform, provider and module versions.

## ✅ Capstone Checklist

- [ ] Custom module + a registry module
- [ ] Remote state with locking
- [ ] `fmt`, `validate`, `test` and a security scan pass
- [ ] CI workflow runs on pull requests
- [ ] README with architecture notes
- [ ] `terraform destroy` works cleanly

---

## 🚀 Go Beyond This Sheet

### 📦 Explore the big repo
The companion repo [**terraform-for-devops**](https://github.com/LondheShubham153/terraform-for-devops) has real, current Terraform for this topic. Clone it and read the code, don't just skim it:
- [`examples/terraform_test/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/examples/terraform_test) – `terraform test` example
- [`eks/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/eks) – production EKS with registry modules
- [`terraform-aws-multi-env`](https://github.com/LondheShubham153/terraform-aws-multi-env) – workspaces + modules
- [`aws-devops`](https://github.com/LondheShubham153/aws-devops/tree/main/terraform) – CI/CD on AWS (pins AWS provider `~> 5.0`, so try upgrading it)

More repos: [github.com/LondheShubham153?q=terraform](https://github.com/LondheShubham153?tab=repositories&q=terraform)

### 🧪 Practice on your own
A cheat sheet only helps once you've typed the commands yourself. Try these without copy-pasting:
- [ ] Create a `staging` workspace and make one value change per workspace.
- [ ] Write your own `.tftest.hcl` that checks a naming rule or a tag.
- [ ] Add the GitHub Actions workflow to your repo and open a PR to watch it run.
- [ ] Run `trivy config .` on your capstone and fix one finding.

> 💡 Break things on purpose, read the error, then fix it. That is how it sticks. Run `terraform destroy` when you're done.

⬅️ Back to [Day 6 tasks](./README.md)
