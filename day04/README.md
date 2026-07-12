# 🗄️ TerraWeek Day 4 — State & Remote Backends (Native Locking)

**Date:** Wednesday, 15th July 2026

Terraform's **state** is the single most important concept for working on a **team**. Today you'll understand what state is, why it's sensitive, and how to store it **remotely and safely** — using the **modern S3 native state locking** (no DynamoDB needed anymore!). 🔐

---

## 🎯 Learning Goals

- Understand **what Terraform state is** and why it exists.
- Use the **`terraform state`** commands to inspect and manipulate state.
- Move from **local** to **remote** state with an **S3 backend**.
- Enable **S3 native state locking** with `use_lockfile` (the 2026 way).
- Safely **import** existing resources into state.

---

## 🆕 What Changed (Important!)

> The old TerraWeek taught **S3 + DynamoDB** for state locking.
> As of **Terraform 1.10** (experimental) and **1.11** (GA), the S3 backend supports **native locking** via a lock file in the bucket — using S3 conditional writes.
> **DynamoDB-based locking is now deprecated** and will be removed in a future release.
> ➡️ For all new work, use **`use_lockfile = true`** and skip DynamoDB entirely.

---

## 📝 Tasks

### Task 1: Why State Matters
Explain in your notes:
- What is the **`terraform.tfstate`** file and what does it store?
- Why should you **never** edit it by hand or commit it to Git?
- What is **state drift**, and how does `terraform plan` / `terraform refresh` relate to it?
- Why is state **sensitive** (it can contain secrets in plaintext)?

### Task 2: Explore Local State & `terraform state`
Start from **any** working config (reuse Day 3's, or the [`./backend_demo`](./backend_demo) here). After an `apply`, practice:
```bash
terraform state list                       # list all managed resources
terraform state show <resource_address>    # inspect one resource
terraform state mv <src> <dest>            # rename/move within state
terraform state rm <resource_address>      # stop managing (does NOT delete infra)
terraform show                             # human-readable state
```
Document what each command does and when you'd use it.

### Task 3: Bootstrap the Backend Infrastructure
The S3 bucket that *holds* your state must exist **before** you configure the backend. Use [`./backend_infra`](./backend_infra) to create it (**local** state for this bootstrap step only):
```bash
cd backend_infra
terraform init
terraform apply    # creates the versioned, encrypted S3 state bucket
```

### Task 4: Configure the Remote Backend with Native Locking
Now point a real config at that bucket. See [`./backend_demo`](./backend_demo):
```hcl
terraform {
  backend "s3" {
    bucket       = "your-unique-terraweek-state-bucket"
    key          = "day04/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true   # ✅ native S3 state locking — no DynamoDB!
  }
}
```
```bash
cd backend_demo
terraform init     # Terraform will offer to migrate local state → S3
terraform apply
```
Verify in the S3 console that your `terraform.tfstate` is uploaded, and watch a `.tflock` file appear/disappear during an apply.

### Task 5: Import an Existing Resource
Create something manually in the console (e.g. an S3 bucket), then bring it under Terraform management using an **`import` block** (Terraform 1.5+):
```hcl
import {
  to = aws_s3_bucket.imported
  id = "my-manually-created-bucket"
}
```
Run `terraform plan -generate-config-out=generated.tf` and review the generated config.

> 📚 **Reference the companion repo** for the full set of state/refactor blocks, each in a commented file:
> [`examples/import.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/import.tf) · [`examples/moved.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/moved.tf) · [`examples/removed.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/removed.tf) · [`examples/check.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/check.tf)

---

## 🧹 Cleanup
```bash
cd backend_demo && terraform destroy
cd ../backend_infra && terraform destroy   # empty the bucket first if versioning blocks it
```

---

## 🍫 Bonus (Brownie Points)
- Compare remote backends: **S3**, **HCP Terraform (Terraform Cloud)**, **Azure Storage**, **GCS**.
- Enable **S3 bucket versioning** and recover a previous state version.
- Try the **`moved`** block to refactor resource addresses without destroy/recreate ([`examples/moved.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/moved.tf)).
- Use a **`removed`** block to stop managing a resource *without deleting it* ([`examples/removed.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/removed.tf)).
- Add a **`check`** block for a continuous health assertion ([`examples/check.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/check.tf)).

---

## 📤 What to Submit
- Blog / LinkedIn / X post: your backend config, a screenshot of state in S3, and the lock file appearing during `apply`.
- Push to your GitHub repo (**remember: never commit `.tfstate`!**). Tag **#TrainWithShubham #TerraWeekChallenge**.

---

📺 **Companion video:** [Terraform In One Shot](https://youtu.be/S9mohJI_R34) (state, backends & refactoring blocks)
💻 **Companion code:** [`examples/import.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/import.tf) · [`moved.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/moved.tf) · [`removed.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/removed.tf) · [S3 Backend docs](https://developer.hashicorp.com/terraform/language/backend/s3)
💬 Questions? [Discord](https://discord.gg/hs3Pmc5F) / [Telegram](https://t.me/trainwithshubham).

### Happy Terraforming! 🌍💻
