# 📦 TerraWeek Day 5 — Modules: Reusable, Composable Infrastructure

**Date:** Thursday, 16th July 2026

Copy-pasting `.tf` blocks doesn't scale. **Modules** let you package infrastructure once and reuse it everywhere — across environments, teams, and projects. Today you'll **write your own module**, **consume registry modules**, and learn **versioning**. ♻️

---

## 🎯 Learning Goals

- Understand **what modules are** and why they're the backbone of scalable Terraform.
- Understand the **root module** vs **child modules**.
- Write a **local module** with clear **inputs (variables)** and **outputs**.
- Consume modules from the **Terraform Registry** and **Git**, and **pin versions**.
- Use **`for_each`** to instantiate a module multiple times.

---

## 📝 Tasks

### Task 1: Modules — the Why
Answer in your notes:
- What is a **module**? What counts as the **root module**?
- What are the benefits — **reusability, consistency, encapsulation, versioning, testing**?
- What files make up a well-structured module (`main.tf`, `variables.tf`, `outputs.tf`, `README.md`)?

### Task 2: Write Your Own Module
Use the **starter code in [`./example`](./example)**. It contains:
- A reusable module at [`./example/modules/ec2_instance`](./example/modules/ec2_instance)
- A **root module** ([`./example`](./example)) that calls it.

Study how the root resolves shared lookups **once** (AMI, subnet, security group) and passes them as **inputs**, then reads the module's **outputs**:
```hcl
module "web_server" {
  source                 = "./modules/ec2_instance"
  name                   = "web"
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id   # resolved in the root
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}

output "web_public_ip" {
  value = module.web_server.public_ip
}
```
> 💡 Notice the module takes **IDs as inputs** instead of doing its own lookups. That keeps it reusable and avoids running the same data source once per instance.
```bash
cd example
terraform init      # note how Terraform initializes the module
terraform plan
terraform apply
terraform destroy
```

### Task 3: Modular Composition (`for_each`)
Instantiate the **same module multiple times** to build multiple servers cleanly:
```hcl
module "servers" {
  source   = "./modules/ec2_instance"
  for_each = toset(["app", "worker", "cache"])

  name                   = each.key
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}
```
Add this to the root module and observe the plan.

### Task 4: Consume a Registry Module + Version Locking
Use a real, popular module from the **[Terraform Registry](https://registry.terraform.io/)** — e.g. the official AWS VPC module — and **pin its version**:
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"   # ✅ always pin registry/git module versions

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"
  # ...
}
```

### Task 5: Ways to Lock Module Versions
Document, with code snippets, **each** way to pin a module source:
- **Registry:** `version = "~> 5.0"` (also `= 5.1.2`, `>= 5.0, < 6.0`).
- **Git tag/ref:** `source = "git::https://github.com/org/repo.git//path?ref=v1.2.0"`.
- **Git commit SHA** for immutability: `?ref=<full-sha>`.
Explain why **pinning matters** (reproducible builds, no surprise breaking changes).

---

> 📚 **Reference the companion repo:** [`aws_module_project/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project) is a real multi-environment example — one reusable [`my_app_infra_module`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project/my_app_infra_module) (EC2 + S3 + DynamoDB) instantiated three times for **dev / stg / prd** with different instance sizes. Study how [`main.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/aws_module_project/main.tf) passes inputs and reads outputs.

## 🧠 `~>` (Pessimistic Constraint) Cheatsheet
- `~> 5.0` → allows `5.x`, **not** `6.0`.
- `~> 5.1.0` → allows `5.1.x`, **not** `5.2.0`.

---

## 🍫 Bonus (Brownie Points)
- Add a **`README.md`** and input **validation** to your module.
- Publish your module to your **own GitHub** and consume it via a `git::` source + `?ref=` tag.
- Explore **module composition**: pass one module's output as another module's input.

---

## 📤 What to Submit
- Blog / LinkedIn / X post: your module structure, the root config calling it, and `terraform plan` showing multiple instances via `for_each`.
- Push to your GitHub repo. Tag **#TrainWithShubham #TerraWeekChallenge**.

---

📺 **Companion video:** [Terraform In One Shot](https://youtu.be/S9mohJI_R34) (Project 2 — reusable multi-env module)
💻 **Companion code:** [`aws_module_project/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project) · [Modules docs](https://developer.hashicorp.com/terraform/language/modules) · [Terraform Registry](https://registry.terraform.io/)
💬 Questions? [Discord](https://discord.gg/hs3Pmc5F) / [Telegram](https://t.me/trainwithshubham).

### Happy Terraforming! 🌍💻
