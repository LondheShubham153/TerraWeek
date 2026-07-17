# 🚀 TerraWeek Capstone — 2-Tier Web App on AWS

A free-tier-safe, security-hardened, fully tested 2-tier web application infrastructure,
built entirely with Terraform as the final project for [TrainWithShubham's TerraWeek
Challenge](https://github.com/saadhussain07/TerraWeek). It reuses almost everything built
across Days 1–6 of the challenge: a custom EC2 module, a registry VPC module, remote state
with native S3 locking, a native `terraform test` suite, a Trivy security gate, and a
GitHub Actions CI/CD pipeline.

---

## 🏗️ Architecture

![Architecture diagram](assets/architecture.svg)

- **Public-subnet-only design, no NAT gateway** — a deliberate trade-off to keep this
  100% free-tier. Tiering is enforced by **security groups**, not network isolation: the
  app tier's security group only accepts traffic from the web tier's security group, never
  from the internet, even though both instances technically sit in public subnets.
- **Two tiers, one module** — both the web and app instances are the exact same
  `ec2_instance` module (`v1.1.0`), just wired to different security groups. Same
  composition idea as the Day 5 module-composition bonus, applied at capstone scale.

---

## 🧱 Infrastructure

| Component | Source | Purpose |
|---|---|---|
| VPC | Registry module (`terraform-aws-modules/vpc/aws ~> 5.0`) | Network foundation, 2 public subnets across 2 AZs |
| Web tier EC2 | Custom module (`terraform-ec2-module` `v1.1.0`) | Public-facing instance, HTTP + restricted SSH |
| App tier EC2 | Custom module (`terraform-ec2-module` `v1.1.0`) | Backend instance, reachable only from the web tier |
| Web tier SG | `aws_security_group` | Allows :80 from anywhere, :22 from operator IP only |
| App tier SG | `aws_security_group` | Allows :8080 and :22 from the web tier SG only |
| Remote state | S3 (`terraweek-2026-state-bucket-by-saadhussain`) | Native locking via `use_lockfile = true`, key `capstone/terraform.tfstate` |
| AMI | `data.aws_ami` (Amazon Linux 2023, resolved once in root module) | Passed into both module instances as an ID, per the module's own best-practice design |

---

## 🔄 Pipeline stages

| Stage | Tool | Needs AWS credentials? |
|---|---|---|
| Format check | `terraform fmt -check -recursive` | ❌ No |
| Init (validate-only) | `terraform init -backend=false` | ❌ No |
| Validate | `terraform validate` | ❌ No |
| Test | `terraform test` (mocked AWS provider) | ❌ No |
| Security scan | Trivy (`config` scan) | ❌ No |
| Plan against real AWS | `terraform plan` | ✅ Yes — needs `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `ALLOWED_SSH_CIDR` repo secrets |

The first five stages run on every push with zero cloud credentials — same principle Day 6
established, just applied to real resource types via a `mock_provider "aws" {}` block
instead of `random_pet`. Only the final plan stage touches real AWS, and only if secrets
are configured.

---

## 🛠️ Tech stack

| Category | Tool |
|---|---|
| IaC | Terraform ≥ 1.11 |
| Cloud | AWS (VPC, EC2, S3) |
| Testing | Native `terraform test`, `mock_provider` |
| Security | Trivy |
| CI/CD | GitHub Actions |
| State | S3 backend, native locking (no DynamoDB table needed) |

---

## ⚡ Quick start

```bash
cd capstone

# 1. Get your IP for the SSH allow-list
curl https://checkip.amazonaws.com

# 2. Init, format, validate — no AWS credentials required for these
terraform init
terraform fmt -check -recursive
terraform validate

# 3. Run the test suite — mocked provider, no real resources touched
terraform test

# 4. Security scan
trivy config .

# 5. Plan and apply — this DOES touch real AWS and creates billable resources
terraform plan -var="allowed_ssh_cidr=YOUR_IP/32"
terraform apply -var="allowed_ssh_cidr=YOUR_IP/32"

# 6. When you're done — always destroy to avoid ongoing charges
terraform destroy -var="allowed_ssh_cidr=YOUR_IP/32"
```

⚠️ `allowed_ssh_cidr` has no default and a validation rule rejecting `0.0.0.0/0` on
purpose — you must pass your own IP explicitly, every time.

To enable the real `plan` job in GitHub Actions, add three repo secrets under
**Settings → Secrets and variables → Actions**: `AWS_ACCESS_KEY_ID`,
`AWS_SECRET_ACCESS_KEY`, and `ALLOWED_SSH_CIDR`.

---

## 🔗 Related projects

Part of the [TerraWeek Challenge](https://github.com/saadhussain07/TerraWeek) —
see [`day01`](../day01) through [`day06`](../day06) for the daily builds this capstone
is composed from.

---

⭐ If this was useful, consider starring the repo!

#TrainWithShubham #TerraWeekChallenge
