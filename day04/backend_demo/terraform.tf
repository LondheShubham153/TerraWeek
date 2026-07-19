terraform {
  required_version = ">= 1.11" # use_lockfile is GA from 1.11

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Remote state in S3 with NATIVE locking. No DynamoDB table required.
  # 👉 Change `bucket` to the name output by ../backend_infra, then run:
  #    terraform init   (Terraform will offer to migrate local state → S3)
  backend "s3" {
    bucket       = "terraweek-2026-state-bucket-by-saadhussain"
    key          = "day04/backend_demo/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # ✅ S3-native state locking (Terraform 1.11+)
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "terraweek-2026"
      ManagedBy = "terraform"
      Day       = "04"
    }
  }
}
