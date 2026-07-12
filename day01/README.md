# 🌱 TerraWeek Day 1 — Introduction to IaC & Terraform Basics

**Date:** Sunday, 12th July 2026

Welcome to **Day 1** of the TerraWeek Challenge! Today is all about **foundations** — understanding *why* Infrastructure as Code exists, installing the **latest Terraform (v1.15.x)**, and running your very first `terraform apply`. 🚀

---

## 🎯 Learning Goals

By the end of today you should be able to:
- Explain what **Infrastructure as Code (IaC)** is and why it matters.
- Describe what **Terraform** is and how it fits into the DevOps workflow.
- Install Terraform and verify it works.
- Understand the **core Terraform workflow** and key terminology.
- Provision your **first resource** — with zero cloud cost.

---

## 📝 Tasks

### Task 1: Understand IaC & Terraform
Write short answers (in your blog/notes) to:
- What is **Infrastructure as Code**, and what problems does it solve compared to clicking around a cloud console?
- What is **Terraform**, and why is it so popular? (Hint: declarative, provider-agnostic, huge ecosystem.)
- **Terraform vs alternatives** — write one line each on how Terraform compares to **OpenTofu**, **Pulumi**, **CloudFormation**, and **Ansible**.

### Task 2: Install Terraform (latest version)
- Install **Terraform ≥ 1.15** using the [official install guide](https://developer.hashicorp.com/terraform/install).
- Verify your install and **paste the output** in your notes:

```bash
terraform version
terraform -help
```
- Install the **HashiCorp Terraform** extension in VS Code for syntax highlighting and autocomplete.

### Task 3: Learn 6 Crucial Terraform Terminologies
Explain each of these **in your own words** with a one-line example:
1. **Provider** — a plugin that lets Terraform talk to a platform (AWS, Azure, Docker…).
2. **Resource** — a piece of infrastructure you want to create (an EC2 instance, an S3 bucket…).
3. **State** — Terraform's record of what it manages (the `terraform.tfstate` file).
4. **Plan** — a preview of the changes Terraform will make.
5. **HCL** — HashiCorp Configuration Language, the syntax you write Terraform in.
6. **Module** — a reusable, packaged group of Terraform configuration.

### Task 4: Your First Terraform Config (no cloud account needed!)
Use the **starter code in [`./example`](./example)** — it uses the `local` and `random` providers, so it costs **nothing** and needs **no credentials**.

Run the **core Terraform workflow** and capture the output of each step:
```bash
cd example
terraform init      # download providers, initialize the working directory
terraform fmt       # format your code
terraform validate  # check for syntax errors
terraform plan      # preview what will be created
terraform apply     # create the resources (type: yes)
cat greeting.txt    # see the file Terraform generated
terraform destroy   # clean up (type: yes)
```

---

## 🔁 The Core Terraform Workflow

```
  Write  ──▶  Init  ──▶  Plan  ──▶  Apply  ──▶  Destroy
  (.tf)     (init)     (preview)   (create)    (clean up)
```

---

## 🍫 Bonus (Brownie Points)
- Set up **tab completion** for the Terraform CLI: `terraform -install-autocomplete`.
- Try **[OpenTofu](https://opentofu.org/)** (the open-source fork) and note the differences.
- Explore the `.terraform.lock.hcl` lock file that gets created — what is it for?

---

## 📤 What to Submit
- A blog / LinkedIn / X post with your learnings + screenshots of `terraform version` and a successful `apply`/`destroy`.
- Push your code to your own **GitHub repo**.
- Tag **#TrainWithShubham #TerraWeekChallenge** and share with your network.

---

📺 **Companion video:** [Terraform In One Shot](https://youtu.be/S9mohJI_R34) (watch the intro + install section)
💻 **Companion code:** [terraform-for-devops](https://github.com/LondheShubham153/terraform-for-devops) — start with its [README](https://github.com/LondheShubham153/terraform-for-devops#readme)
💬 Stuck? Ask in the [Discord](https://discord.gg/hs3Pmc5F) / [Telegram](https://t.me/trainwithshubham) community.

### Happy Terraforming! 🌍💻
