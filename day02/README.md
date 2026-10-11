# 🧩 TerraWeek Day 2 — HCL Deep Dive: Variables, Types & Expressions

**Date:** Monday, 12th October 2026

Yesterday you ran your first `apply`. Today you'll learn the **language** behind it — **HCL (HashiCorp Configuration Language)** — so your configs become flexible, reusable, and readable. ✍️

---

## 🎯 Learning Goals

- Understand HCL **blocks, arguments, and expressions**.
- Use **input variables** with types, defaults, validation, and `sensitive`.
- Use **`locals`**, **`outputs`**, and built-in **functions**.
- Understand **variable precedence** (`tfvars`, `-var`, env vars).

---

> 📄 **Quick reference:** keep the [Day 2 Cheat Sheet](./CHEATSHEET.md) open while you work.

## 📝 Tasks

### Task 1: Master HCL Syntax
Explain (with examples) in your notes:
- The anatomy of a **block**: `block_type "label_one" "label_two" { argument = value }`.
- The difference between an **argument** and a **block**.
- **Expressions**: string interpolation `"${...}"`, references (`resource.name.attr`), and operators.

### Task 2: Variables, Types & Validation
Create a `variables.tf` and define variables covering **each major type**:
- Primitives: `string`, `number`, `bool`
- Collections: `list(string)`, `map(string)`, `set(string)`
- Structural: `object({...})`, `tuple([...])`

Add at least one variable with:
- a **`default`**,
- a **`validation`** block (e.g. only allow certain values),
- the **`sensitive = true`** flag.

```hcl
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
```

### Task 3: Locals, Outputs & Functions
- Use a **`locals`** block to compute a value (e.g. a common `name_prefix` or merged tags).
- Add **`outputs`** that expose useful values.
- Use at least **3 built-in functions** — e.g. `upper()`, `merge()`, `join()`, `lookup()`, `length()`, `format()`.
  Explore them live with `terraform console`:
```bash
terraform console
> upper("terraweek")
> merge({a=1}, {b=2})
> join("-", ["tws", "terraweek", "2026"])
```

### Task 4: Build Something Real (Docker provider — no cloud cost)
Use the **starter code in [`./example`](./example)**. It uses the **`kreuzwerker/docker`** provider to pull an Nginx image and run a container — fully driven by variables.

> 🐳 **Prereq:** Docker installed and running. Prefer cloud? Swap the Docker resources for a `local_file` driven by your variables — the HCL concepts are identical.

```bash
cd example
terraform init
terraform plan  -var 'container_name=tws-web' -var 'external_port=8080'
terraform apply -var 'container_name=tws-web' -var 'external_port=8080'
# visit http://localhost:8080
terraform output
terraform destroy -var 'container_name=tws-web' -var 'external_port=8080'
```

Then try the same run using a **`terraform.tfvars`** file instead of `-var` flags and note the difference.

---

## 📊 Variable Precedence (highest wins)
```
-var / -var-file  ▶  *.auto.tfvars  ▶  terraform.tfvars  ▶  TF_VAR_ env vars  ▶  default
```

---

## 🍫 Bonus (Brownie Points)
- Add a **`for` expression** to transform a list/map (e.g. `[for s in var.names : upper(s)]`).
- Use a **conditional expression**: `var.environment == "prod" ? "t3.medium" : "t3.micro"`.
- Try **`optional()`** attributes inside an `object` type.

---

## 🗂️ Example Code from the Repos

Study these real, up-to-date examples (Terraform ≥ 1.5, AWS provider `~> 6.0`) alongside today's tasks — read them, run them, then modify them:

| Example | What it shows |
|---|---|
| [`variables.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/variables.tf) | Typed input variables with defaults |
| [`outputs.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/outputs.tf) | Output values |
| [`examples/validation.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/validation.tf) | 5 variable `validation` patterns |

> 🧭 More Terraform repos: [github.com/LondheShubham153?q=terraform](https://github.com/LondheShubham153?tab=repositories&q=terraform)

---

## 📤 Wrap Up
- Keep notes on: your `variables.tf`, a `terraform console` screenshot, and your running container/output.
- Push to your GitHub repo. (Optional) Share with **#TrainWithShubham #TerraWeekChallenge**.

---

📺 **Companion video:** [Terraform In One Shot](https://youtu.be/S9mohJI_R34) (HCL, variables & validation)
💻 **Companion code:** [`examples/validation.tf`](https://github.com/LondheShubham153/terraform-for-devops/blob/main/examples/validation.tf) — 5 real validation patterns · [Config Language docs](https://developer.hashicorp.com/terraform/language)
💬 Questions? [Discord](https://discord.gg/hs3Pmc5F) / [Telegram](https://t.me/trainwithshubham).

### Happy Terraforming! 🌍💻
