# 🗃️ Day 4 Cheat Sheet: State & Remote Backends

A quick reference for the state commands and the S3 remote backend used in [Day 4](./README.md).

> ⚠️ State can contain **secrets in plaintext**. Never commit `*.tfstate` to Git.

---

## 📋 State Commands

```bash
terraform state list                          # list every resource Terraform manages
terraform state list aws_s3_bucket.*          # filter by address pattern
terraform state show aws_s3_bucket.demo       # inspect one resource's attributes
terraform show                                # human-readable view of the whole state
terraform state mv aws_s3_bucket.old aws_s3_bucket.new   # rename/move in state (no infra change)
terraform state rm aws_s3_bucket.demo         # stop managing it (does NOT delete the real resource)
terraform state pull > backup.tfstate         # download current state (works with remote backends)
terraform state push backup.tfstate           # upload state (use with care!)
terraform refresh                             # sync state with real infra (prefer: terraform apply -refresh-only)
terraform apply -refresh-only                 # review + accept drift into state
terraform force-unlock <LOCK_ID>              # release a stuck lock (last resort)
```

> 💡 Prefer the declarative `moved`, `removed` and `import` blocks over `state mv` / `state rm` / `terraform import` for changes you want reviewed in a PR.

---

## ☁️ Remote Backend with S3 (native locking)

Requires **Terraform ≥ 1.11**. No DynamoDB table needed — locking is done with a `.tflock` file in the bucket.

### 1. Create the state bucket (once, with local state)

```hcl
resource "aws_s3_bucket" "state" {
  bucket = "my-unique-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled" # keep history so you can recover from mistakes
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

Full working version: [`backend_infra/`](./backend_infra)

### 2. Point your config at the bucket

```hcl
terraform {
  required_version = ">= 1.11"

  backend "s3" {
    bucket       = "my-unique-terraform-state-bucket"
    key          = "day04/backend_demo/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # ✅ S3-native locking
  }
}
```

Full working version: [`backend_demo/`](./backend_demo)

> The `backend` block can't use variables. Pass values with `-backend-config` or a file if you need them dynamic.

### 3. Initialise / migrate

```bash
terraform init                 # Terraform offers to copy local state → S3 (answer: yes)
terraform init -migrate-state  # force a migration after changing the backend
terraform init -reconfigure    # switch backend config without migrating
terraform apply                # watch a .tflock file appear and disappear in the bucket
```

---

## ❌ Don't use the old DynamoDB locking

```hcl
backend "s3" {
  dynamodb_table = "terraform-locks"   # ❌ deprecated — use use_lockfile = true instead
}
```

---

## 🔗 Docs

- [S3 backend docs](https://developer.hashicorp.com/terraform/language/backend/s3)
- [State docs](https://developer.hashicorp.com/terraform/language/state)

---

## 🚀 Go Beyond This Sheet

### 📦 Explore the big repo
The companion repo [**terraform-for-devops**](https://github.com/LondheShubham153/terraform-for-devops) has real, current Terraform for this topic. Clone it and read the code, don't just skim it:
- [`examples/import.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/import.tf)
- [`examples/moved.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/moved.tf)
- [`examples/removed.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/removed.tf)
- [`examples/check.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/check.tf)

More repos: [github.com/LondheShubham153?q=terraform](https://github.com/LondheShubham153?tab=repositories&q=terraform)

### 🧪 Practice on your own
A cheat sheet only helps once you've typed the commands yourself. Try these without copy-pasting:
- [ ] Create the state bucket, then migrate a local state to S3 and confirm the `.tflock` file appears during `apply`.
- [ ] Use `terraform state list`, `show`, `mv` and `rm` on a throwaway config.
- [ ] Import a bucket you created by hand using an `import` block.
- [ ] Refactor a resource name with a `moved` block and check that `plan` shows no changes.

> 💡 Break things on purpose, read the error, then fix it. That is how it sticks. Run `terraform destroy` when you're done.

⬅️ Back to [Day 4 tasks](./README.md)
