# 🧱 Day 5 Cheat Sheet: Modules

Quick reference for [Day 5](./README.md).

---

## 📁 Module Layout

```
modules/
└── s3_bucket/
    ├── main.tf        # resources
    ├── variables.tf   # inputs
    └── outputs.tf     # outputs
main.tf                # root config that calls the module
```

## 📥 Inputs & Outputs (inside the module)

```hcl
# modules/s3_bucket/variables.tf
variable "bucket_name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}

# modules/s3_bucket/main.tf
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

# modules/s3_bucket/outputs.tf
output "bucket_arn" { value = aws_s3_bucket.this.arn }
```

## 📞 Calling a Module

```hcl
module "logs" {
  source      = "./modules/s3_bucket"
  bucket_name = "tws-logs-${var.environment}"
  tags        = local.tags
}

output "logs_arn" { value = module.logs.bucket_arn }   # module.<name>.<output>
```

## 🔁 One Module, Many Copies

```hcl
module "env" {
  for_each    = toset(["dev", "stg", "prd"])
  source      = "./modules/s3_bucket"
  bucket_name = "tws-${each.key}-data"
}
```

## 🌍 Registry & Git Modules (pin the version!)

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"
  name    = "tws-vpc"
  cidr    = "10.0.0.0/16"
}

module "from_git" {
  source = "git::https://github.com/org/repo.git//modules/x?ref=v1.2.0"
}
```

## 🛠️ Commands

```bash
terraform init -upgrade                 # re-fetch modules and providers
terraform get                           # download modules only
terraform plan -target=module.logs      # focus on one module (debug only)
terraform state list | grep module      # see module resources
```

## ✅ Good Module Habits

- Small, single-purpose modules with clear inputs and outputs.
- Pin versions of registry and Git modules.
- Don't put `provider` configuration inside reusable modules.
- Add a `README.md` and examples for each module.

---

## 🚀 Go Beyond This Sheet

### 📦 Explore the big repo
The companion repo [**terraform-for-devops**](https://github.com/LondheShubham153/terraform-for-devops) has real, current Terraform for this topic. Clone it and read the code, don't just skim it:
- [`aws_module_project/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project) – one module deployed for dev / stg / prd
- [`aws_module_project/my_app_infra_module/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project/my_app_infra_module) – a module with variables and outputs
- [`terraform-aws-multi-env/modules/`](https://github.com/LondheShubham153/terraform-aws-multi-env/tree/main/modules) – separate `ec2`, `s3` and `dynamodb` modules

More repos: [github.com/LondheShubham153?q=terraform](https://github.com/LondheShubham153?tab=repositories&q=terraform)

### 🧪 Practice on your own
A cheat sheet only helps once you've typed the commands yourself. Try these without copy-pasting:
- [ ] Take your Day 3 resources and move them into a module, with no behaviour change in `plan`.
- [ ] Call that module three times with `for_each` for dev, stg and prd.
- [ ] Swap one of your resources for a registry module and pin its version.
- [ ] Add an output and consume it from another module.

> 💡 Break things on purpose, read the error, then fix it. That is how it sticks. Run `terraform destroy` when you're done.

⬅️ Back to [Day 5 tasks](./README.md)
