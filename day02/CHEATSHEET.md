# 🧩 Day 2 Cheat Sheet: HCL, Variables & Expressions

Quick reference for [Day 2](./README.md).

---

## 🧱 Block Anatomy

```hcl
block_type "label_one" "label_two" {
  argument = value
}
```

## 🔤 Variable Types

```hcl
variable "name"    { type = string }
variable "count_n" { type = number }
variable "enabled" { type = bool }
variable "azs"     { type = list(string) }
variable "tags"    { type = map(string) }
variable "ids"     { type = set(string) }
variable "server" {
  type = object({
    name = string
    port = number
  })
}
```

## ✅ Validation, Defaults & Sensitive

```hcl
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "db_password" {
  type      = string
  sensitive = true
}
```

## 📍 Locals & Outputs

```hcl
locals {
  name_prefix = "tws-${var.environment}"
  tags        = merge(var.tags, { ManagedBy = "terraform" })
}

output "prefix" {
  value = local.name_prefix
}
```

## ⚙️ Useful Functions (try them in `terraform console`)

```hcl
upper("terraweek")                       # TERRAWEEK
join("-", ["tws", "terraweek"])          # tws-terraweek
merge({a = 1}, {b = 2})                  # {a=1, b=2}
lookup({a = 1}, "a", 0)                  # 1
length(["a", "b"])                       # 2
format("%s-%03d", "web", 7)              # web-007
[for s in var.names : upper(s)]          # for expression
var.enabled ? "yes" : "no"               # conditional
```

## 🔀 Ways to Set Variables

```bash
terraform apply -var 'environment=prod'
terraform apply -var-file=prod.tfvars
export TF_VAR_environment=prod
```

Precedence (highest first): `-var` / `-var-file` → `*.auto.tfvars` → `terraform.tfvars` → `TF_VAR_*` → `default`.

---

## 🚀 Go Beyond This Sheet

### 📦 Explore the big repo
The companion repo [**terraform-for-devops**](https://github.com/LondheShubham153/terraform-for-devops) has real, current Terraform for this topic. Clone it and read the code, don't just skim it:
- [`examples/validation.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/validation.tf) – 5 validation patterns
- [`variables.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/variables.tf) – typed variables with defaults
- [`outputs.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/outputs.tf) – outputs

More repos: [github.com/LondheShubham153?q=terraform](https://github.com/LondheShubham153?tab=repositories&q=terraform)

### 🧪 Practice on your own
A cheat sheet only helps once you've typed the commands yourself. Try these without copy-pasting:
- [ ] Write a variable for each type and print them with `output` blocks.
- [ ] Add a `validation` that rejects bad input, then trigger the error on purpose.
- [ ] Use a `for` expression to turn a list into a map.
- [ ] Run the same config with `-var`, then a `.tfvars` file, then `TF_VAR_`, and compare.

> 💡 Break things on purpose, read the error, then fix it. That is how it sticks. Run `terraform destroy` when you're done.

⬅️ Back to [Day 2 tasks](./README.md)
