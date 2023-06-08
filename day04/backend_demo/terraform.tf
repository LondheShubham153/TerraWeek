terraform {

required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }

backend "s3" {
	bucket = "terraweek-demo-state-bucket" 
	key = "terraform.tfstate"
	region = "us-east-1"
	dynamodb_table = "terraweek-demo-state-table"
}
}
