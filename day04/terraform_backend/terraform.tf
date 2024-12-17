terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.80.0"
    }
  }
  backend "s3" {
    bucket = "terraweek-day04-bucket-name"
    key = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraweek-day04-table-name"
  }
}
