# 🚀 TerraWeek Capstone — 2-Tier Web App on AWS

A free-tier-safe, security-hardened, fully tested 2-tier web application infrastructure —
the final project for [TrainWithShubham's TerraWeek Challenge](https://github.com/saadhussain07/TerraWeek).
It reuses almost everything built across Days 1–6: a custom EC2 module (used twice), a
registry VPC module, remote state with native S3 locking, a native `terraform test` suite,
a Trivy security gate, and a GitHub Actions CI/CD pipeline that runs a real `terraform plan`
against live AWS on every push.

**Status: deployed, verified, and destroyed cleanly.** Every command below was actually run
against real AWS — not just planned. Screenshots throughout this README are proof, not mockups.

---

## 🏗️ Architecture

![Architecture diagram](assets/architecture.png)

- **Public-subnet-only design, no NAT gateway** — a deliberate trade-off to keep this
  100% free-tier. Tiering is enforced by **security groups**, not network isolation: the
  app tier's security group only accepts traffic from the web tier's security group, never
  from the internet — verified live, see [Proof of Work](#-proof-of-work) below.
- **Two tiers, one module** — both the web and app instances are the exact same
  `ec2_instance` module (`v1.1.0`), just wired to different security groups. Same
  composition idea as the Day 5 module-composition bonus, applied at capstone scale.

---

## 🧱 Infrastructure

| Component | Source | Purpose |
|---|---|---|
| VPC (`10.20.0.0/16`) | Registry module (`terraform-aws-modules/vpc/aws ~> 5.0`) | Network foundation, 2 public subnets across 2 AZs |
| Web tier EC2 | Custom module (`terraform-ec2-module` `v1.1.0`) | Public-facing instance, HTTP + restricted SSH |
| App tier EC2 | Custom module (`terraform-ec2-module` `v1.1.0`) | Backend instance, reachable only from the web tier |
| Web tier SG | `aws_security_group` | Allows :80 from anywhere, :22 from operator IP only |
| App tier SG | `aws_security_group` | Allows :8080 and :22 from the web tier SG only |
| Remote state | S3 (`terraweek-2026-state-bucket-by-saadhussain`) | Native locking via `use_lockfile = true`, key `capstone/terraform.tfstate` |
| AMI | `data.aws_ami` (Amazon Linux 2023, resolved once in root module) | Passed into both module instances as an ID |

---

## 🔄 Pipeline stages

| Stage | Tool | Needs AWS credentials? |
|---|---|---|
| Format check | `terraform fmt -check -recursive` | ❌ No |
| Init (validate-only) | `terraform init -backend=false` | ❌ No |
| Validate | `terraform validate` | ❌ No |
| Test | `terraform test` (mocked provider) | ❌ No |
| Security scan | Trivy (`config` scan) | ❌ No |
| Plan against real AWS | `terraform plan` | ✅ Yes — `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `ALLOWED_SSH_CIDR` repo secrets |

The first five stages run on every push with zero cloud credentials, via a
`mock_provider "aws" {}` block. The workflow lives at the **repo root**
(`.github/workflows/capstone.yml`) — GitHub Actions only scans that exact path, not a
subfolder's `.github/`, a real gotcha hit and fixed during this build.

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

## 📸 Proof of Work

| Screenshot | What it shows |
|---|---|
| `assets/tf_init.png` | `terraform init` — backend configured, AWS provider v6.55.0, both modules downloaded |
| `assets/tf_fmt_val.png` | `terraform fmt -check` (silent pass) and `terraform validate` — clean, one upstream-only deprecation warning from the registry VPC module |
| `assets/tf_test_pass.png` | `terraform test` — 3/3 runs pass using `mock_provider "aws" {}`, zero AWS credentials touched |
| `assets/tf_plan.png` | `terraform plan` — 15 to add, 0 to change, 0 to destroy; confirms IMDSv2 required, root volume encrypted, egress narrowed to 80/443, app tier ingress with no `cidr_blocks` at all |
| `assets/tf_apply.png` | `terraform apply` — **15 added, 0 changed, 0 destroyed**. Real outputs: `web_public_ip = 98.92.177.242`, `app_public_ip = 44.203.54.251` |
| `assets/sg_dropping_connection .png` | `curl --connect-timeout 5 http://44.203.54.251:8080` from an outside machine — **times out after 5s (curl error 28)**, proving the app tier's security group genuinely drops external traffic rather than just lacking a listener |
| `assets/capstone_ci_running.png` | GitHub Actions — "Capstone CI" workflow, both `Validate & Test` and `Plan Against Real AWS` jobs running end to end |
| `assets/tf_plan_in_ci.png` | The CI-run `terraform plan` step itself — same result as the local plan (`15 to add, 0 to change, 0 to destroy`), confirming local/CI parity |
| `assets/pipeline_trivy_scan.png` | Trivy security scan step passing inside the CI pipeline |
| `assets/tf_destroy.png` | `terraform destroy` — **15 destroyed**, clean teardown, nothing left running or billing |

The security-boundary proof is the centerpiece of this project: hitting the web tier on
port 80 returns a fast **connection refused** (network path open, nothing listening — no
app was deployed, out of scope for this exercise), while hitting the app tier on port 8080
from the same machine hangs and **times out** — a completely different failure signature
that shows the security group is actively dropping the packet, not just that nothing
answered.

---

## ⚡ Quick start

```bash
cd capstone

# 1. Get your IP for the SSH allow-list
curl.exe https://checkip.amazonaws.com   # PowerShell: use curl.exe, not the alias

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

# 6. Verify the security boundary
curl.exe http://<web_public_ip>                              # fast refusal — expected, no app deployed
curl.exe --connect-timeout 5 http://<app_public_ip>:8080      # should TIME OUT — proves SG isolation

# 7. When you're done — always destroy to avoid ongoing charges
terraform destroy -var="allowed_ssh_cidr=YOUR_IP/32"
```

⚠️ `allowed_ssh_cidr` has no default and has a validation rule rejecting `0.0.0.0/0` on
purpose — you must pass your own IP explicitly, every time.

To enable the real `plan` job in GitHub Actions, add three repo secrets under
**Settings → Secrets and variables → Actions**: `AWS_ACCESS_KEY_ID`,
`AWS_SECRET_ACCESS_KEY`, and `ALLOWED_SSH_CIDR`. The workflow file must live at
`<repo-root>/.github/workflows/capstone.yml` — not nested inside `capstone/`.

---

## 🔍 Trade-offs, documented on purpose

- **VPC Flow Logs disabled** (AWS-0178, MEDIUM) — accepted. Enabling it means standing up
  an extra CloudWatch Log Group + IAM role just for this exercise; out of scope here, would
  enable in a real production environment.
- **Egress to `0.0.0.0/0`** (AWS-0104, CRITICAL per Trivy) — port scope was narrowed from
  all-ports/all-protocols to just 80/443, which is the security-relevant fix. Restricting
  the destination IP further would mean hardcoding Amazon's package-repository and API IP
  ranges, which shift over time and aren't meant to be pinned by hand. Ingress remains the
  enforced boundary (see the security-boundary proof above) — that's where this design's
  actual security guarantee lives.
- **Both instances get public IPs** — the `ec2_instance` module doesn't expose a way to
  disable public IP assignment per-instance (controlled at the subnet level, and this
  design uses public-subnet-only with no NAT). The app tier's protection comes entirely
  from its security group, not from lacking a public IP — and the live `curl` timeout test
  above confirms that protection actually holds.

---

## 🔗 Related projects

Part of the [TerraWeek Challenge](https://github.com/saadhussain07/TerraWeek) —
see [`day01`](../day01) through [`day06`](../day06) for the daily builds this capstone
is composed from.

---

⭐ If this was useful, consider starring the repo!

#TrainWithShubham #TerraWeekChallenge