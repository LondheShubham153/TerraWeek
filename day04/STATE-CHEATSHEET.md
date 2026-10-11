# 🗃️ Terraform State Cheat Sheet

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

## 🔗 More

- [Day 4 tasks](./README.md)
- [S3 backend docs](https://developer.hashicorp.com/terraform/language/backend/s3)
- [State docs](https://developer.hashicorp.com/terraform/language/state)
- [`examples/import.tf`, `moved.tf`, `removed.tf`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/examples) in the companion repo
