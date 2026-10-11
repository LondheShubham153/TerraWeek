# 🌱 Day 1 Cheat Sheet: Terraform Basics

Quick reference for [Day 1](./README.md).

---

## 🔁 Core Workflow

```bash
terraform init       # download providers, set up the working directory
terraform fmt        # format code
terraform validate   # check syntax
terraform plan       # preview changes
terraform apply      # create/update resources (type: yes)
terraform destroy    # tear everything down
```

## 🧰 Handy CLI Commands

```bash
terraform version                 # installed version + providers
terraform -help                   # list commands
terraform -install-autocomplete   # tab completion
terraform plan -out=tfplan        # save a plan
terraform apply tfplan            # apply exactly that plan
terraform apply -auto-approve     # skip the prompt (careful!)
terraform output                  # show output values
```

## 🧱 Minimal Config

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = "my-unique-bucket-name"
}
```

## 📖 6 Key Terms

| Term | Meaning |
|---|---|
| Provider | Plugin that talks to a platform (AWS, Docker…) |
| Resource | A thing Terraform creates and manages |
| State | Terraform's record of what it manages |
| Plan | Preview of the changes |
| HCL | The language you write Terraform in |
| Module | Reusable group of configuration |

## 📁 Files Terraform Creates

| File / folder | Commit to Git? |
|---|---|
| `.terraform/` | ❌ No |
| `terraform.tfstate` | ❌ Never |
| `.terraform.lock.hcl` | ✅ Yes |
| `*.tf` | ✅ Yes |

---

## 🚀 Go Beyond This Sheet

### 📦 Explore the big repo
The companion repo [**terraform-for-devops**](https://github.com/LondheShubham153/terraform-for-devops) has real, current Terraform for this topic. Clone it and read the code, don't just skim it:
- [`terraform.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/terraform.tf) – a modern `terraform {}` block
- [`.terraform-version`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/.terraform-version) – pinning the CLI version
- [`ec2.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/ec2.tf) – a first real AWS resource

More repos: [github.com/LondheShubham153?q=terraform](https://github.com/LondheShubham153?tab=repositories&q=terraform)

### 🧪 Practice on your own
A cheat sheet only helps once you've typed the commands yourself. Try these without copy-pasting:
- [ ] Install Terraform, then run the full workflow on your own config without looking at the commands.
- [ ] Change one argument and read what `terraform plan` says (`+`, `~`, `-/+`).
- [ ] Open `.terraform.lock.hcl` and explain what it is for.
- [ ] Write a config with the `local_file` resource and a `random_pet`.

> 💡 Break things on purpose, read the error, then fix it. That is how it sticks. Run `terraform destroy` when you're done.

⬅️ Back to [Day 1 tasks](./README.md)
