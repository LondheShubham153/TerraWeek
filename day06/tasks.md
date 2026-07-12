# 🚀 TerraWeek Day 6 — Advanced Terraform + Capstone Project

**Date:** Friday, 17th July 2026

The finale! 🎉 Today you'll level up with **workspaces**, the native **`terraform test`** framework, **security scanning**, **CI/CD**, and **best practices** — then tie everything together in a **Capstone Project** you can show off in interviews.

---

## 🎯 Learning Goals

- Manage multiple environments with **workspaces**.
- Automatically **format, validate, and test** Terraform (`fmt`, `validate`, `test`).
- **Scan for security issues** before you apply.
- Automate Terraform in **CI/CD** (GitHub Actions).
- Know the **production best practices** — and prove them in a capstone.

---

## 📝 Tasks

### Task 1: Workspaces & Environments
- Learn what **workspaces** are and how they isolate state per environment.
```bash
terraform workspace list
terraform workspace new staging
terraform workspace select staging
terraform workspace show
```
- Use `terraform.workspace` in your config (e.g. size things differently per env):
```hcl
locals {
  instance_type = terraform.workspace == "prod" ? "t3.medium" : "t3.micro"
}
```
- Discuss the **trade-offs**: workspaces vs separate directories/backends per environment.

### Task 2: Quality Gates — `fmt`, `validate`, `test`
- Format and validate everything:
```bash
terraform fmt -recursive
terraform validate
```
- Write a **native test** with the **`terraform test`** framework (Terraform 1.6+). See [`./example/tests/basic.tftest.hcl`](./example/tests/basic.tftest.hcl):
```bash
cd example
terraform init
terraform test
```
Explain the difference between a `plan`-based `command` and an `apply`-based one in a test.

> 📚 **Reference:** [`examples/terraform_test/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/examples/terraform_test) in the companion repo shows tests asserting on bucket naming, tags, and versioning.

### Task 3: Security & Cost Scanning
Run a static analysis tool against your Day 3 or Day 5 code and fix what it flags:
- **[Trivy](https://github.com/aquasecurity/trivy)**: `trivy config .`
- or **[Checkov](https://www.checkov.io/)**: `checkov -d .`
- or **[tfsec](https://github.com/aquasecurity/tfsec)** (now part of Trivy).
- **Bonus:** estimate cloud cost of a plan with **[Infracost](https://www.infracost.io/)**.

### Task 4: CI/CD with GitHub Actions
- Use the starter workflow at [`./example/.github-workflow-example.yml`](./example/.github-workflow-example.yml).
- Copy it to `.github/workflows/terraform.yml` in your repo.
- It runs `fmt -check`, `init`, `validate`, and `plan` on every PR. Explain each step.

### Task 5: Best Practices Checklist
Document how your capstone honors these:
- ✅ Remote state with locking (Day 4) — **never commit `.tfstate`**.
- ✅ **Pin** Terraform + provider + module versions.
- ✅ Reusable **modules** (Day 5), consistent naming & tagging.
- ✅ **No hard-coded secrets** — use variables / env / a secrets manager.
- ✅ `fmt` + `validate` + `test` + a security scan in CI.
- ✅ A clear **`README.md`** and a working `terraform destroy`.

---

## 🚫 A Note on Provisioners (`remote-exec` / `local-exec`)

You'll see older tutorials configure servers with **provisioners** over SSH. HashiCorp calls these a **last resort**, and here's why:
- They break Terraform's declarative model — Terraform can't track what a script did.
- They need SSH keys + open ingress, and fail unpredictably on retries/replacements.

**Modern alternatives (use these instead):**
- **`user_data`** / cloud-init for boot-time setup (what we used on Day 3).
- **Baked images** with Packer.
- **Config management** (Ansible) or **containers** for app-level setup.

Know provisioners exist and how to read them — but reach for them last.

---

## 🏗️ CAPSTONE PROJECT — Build Your Own Infra

Bring the whole week together. **Design and deploy a small but real project** on AWS / Azure / GCP / Utho. Ideas:
- A **2-tier web app**: VPC + public/private subnets + EC2/ASG + security groups + an S3 bucket.
- A **static website**: S3 + CloudFront (+ optional Route53).
- A **containerized app** on ECS/Fargate or a small EKS/AKS/GKE cluster.

### 🧭 Reference Implementations (companion repo)
Two production-grade blueprints to study and adapt — don't just copy, **understand and extend** them:
- 🏢 **Multi-environment app** → [`aws_module_project/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project): one reusable module deployed to dev/stg/prd — a great template for requirement #1 (custom module).
- ☸️ **Production EKS cluster** → [`eks/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/eks): VPC + EKS via official **registry modules** (VPC `~> 6.0`, EKS `~> 21.0`, Kubernetes **1.35**), Pod Identity, SPOT node groups. Perfect for requirements #1 **and** #2 (registry module).
  > ⚠️ **Cost warning:** an EKS cluster + 2 NAT gateways is **~$155/mo**. Only spin it up briefly and run `terraform destroy` immediately after. Beginners: start with the multi-env app.

**Requirements:**
1. Use at least **one custom module** and **one registry module**.
2. Use **remote state with native S3 locking**.
3. Drive everything with **variables** + sensible **outputs**.
4. Pass **`fmt`**, **`validate`**, a **security scan**, and at least one **`terraform test`**.
5. Wire up the **GitHub Actions** workflow.
6. Write a **`README.md`** with an architecture diagram and run instructions.
7. **`terraform destroy`** cleanly when done.

---

## 🍫 Bonus (Brownie Points)
- Use **HCP Terraform (Terraform Cloud)** for remote runs + a private module registry.
- Add **pre-commit hooks** (`terraform fmt`, `tflint`, `trivy`).
- Explore **ephemeral resources / write-only arguments** (Terraform 1.10–1.11) for secret handling.
- Try **OpenTofu** as a drop-in and compare.

---

## 📤 What to Submit (Final!)
- A blog / LinkedIn / X post with your **capstone architecture**, code repo link, and demo screenshots.
- Your complete **GitHub repo** for the whole week.
- Tag **#TrainWithShubham #TerraWeekChallenge**, tag **[@Shubham Londhe](https://www.linkedin.com/in/shubhamlondhe1996/)**, and share with your network.

> 🎓 Completed all 6 days + learned in public? You've earned your **Python For DevOps [AI Powered] Cohort** access — and a shot at the **Top 3** prize! 🏆

---

📺 **Companion video:** [Terraform In One Shot](https://youtu.be/S9mohJI_R34) (Project 3 — EKS + testing & best practices)
💻 **Companion code:** [`examples/terraform_test/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/examples/terraform_test) · [`eks/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/eks) · [Testing docs](https://developer.hashicorp.com/terraform/language/tests) · [Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)
💬 Questions? [Discord](https://discord.gg/hs3Pmc5F) / [Telegram](https://t.me/trainwithshubham).

### 🎉 Congratulations on completing the TWS TerraWeek Challenge 2026! Happy Terraforming! 🌍💻
