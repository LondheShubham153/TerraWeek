terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "terraweek-2026"
      ManagedBy = "terraform"
      Day       = "03"
    }
  }
}

# --- Bonus: a second, aliased provider config for a different region ---
# Use case: you'd reach for this when a single config needs resources in
# more than one region at once — e.g. a primary stack in us-east-1 plus an
# S3 bucket replicated to us-west-2 for disaster recovery, or a global
# CloudFront + ACM certificate setup that requires us-east-1 specifically
# regardless of where the rest of your infra lives.
provider "aws" {
  alias  = "dr"
  region = var.dr_region

  default_tags {
    tags = {
      Project   = "terraweek-2026"
      ManagedBy = "terraform"
      Day       = "03"
      Role      = "dr-region"
    }
  }
}
