TerraWeek Day 2

# Learn about HCL blocks, parameters, and arguments ?

- In Terraform, the HashiCorp Configuration Language (HCL) is used to define infrastructure resources and their configurations. The main building block in HCL is the block.

## Block
- A block in HCL consists of a block type, block labels, and block arguments. It has the following syntax:

block_type block_label {
  argument_name = argument_value
  ...
}

## Parameters: 
- Parameters are generally used to refer to the inputs or variables that are defined in a Terraform module or configuration.

## Arguments:
- Arguments are the actual values provided to the parameters or block attributes within a Terraform module or configuration.


# Terraform provides several types of resources and data sources that you can use to define and interact with different infrastructure components. Here are some commonly used types:

## Resource Types:

1) aws_instance: Represents an EC2 instance in Amazon Web Services (AWS).
2) azurerm_virtual_machine: Represents a virtual machine in Microsoft Azure.
3) google_compute_instance: Represents a virtual machine in Google Cloud Platform (GCP).
4) docker_container: Represents a Docker container.
5) kubernetes_deployment: Represents a deployment in Kubernetes.
6) aws_s3_bucket: Represents an S3 bucket in AWS.
7) google_storage_bucket: Represents a storage bucket in GCP.
8) aws_lambda_function: Represents an AWS Lambda function.
9) google_cloudfunctions_function: Represents a Google Cloud Function.

## Data Sources:

1) aws_ami: Fetches information about an Amazon Machine Image (AMI) in AWS.
2) azurerm_virtual_machine: Retrieves details about a virtual machine in Azure.
3) google_compute_network: Retrieves information about a network in GCP.
4) docker_image: Fetches information about a Docker image.
5) github_repository: Retrieves information about a GitHub repository.
6) local_file: Retrieves content from a local file.
7) terraform_remote_state: Retrieves outputs from a remote Terraform state.

# Variables and Data Types

variable "my_string_variable" {
  type    = string
  default = "Hello, World!"
}

variable "my_number_variable" {
  type    = number
  default = 42
}

variable "my_boolean_variable" {
  type    = bool
  default = true
}

variable "my_list_variable" {
  type    = list
  default = ["item1", "item2", "item3"]
}

variable "my_map_variable" {
  type    = map
  default = {
    key1 = "value1"
    key2 = "value2"
  }
}

variable "my_object_variable" {
  type = object({
    attribute1 = string
    attribute2 = number
  })
  default = {
    attribute1 = "Hello"
    attribute2 = 123
  }
}


# Create a variables.tf file and define a variable Use the variable in a main.tf file to create a "local_file" resource 

## variabel.tf file
variable "path" {
    type = string
    default = "/home/ubuntu/terraform-course-TWS/terraform-variables/auto_generated_file.txt"
}

## main.tf file
resource "local_file" "my_local_file" {
    filepath = var.path
    content = "this file uses variable"
}

## HCL code to create ec2 instance

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = " ~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ec2_instance" {
  count = 3
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform_TWS_challenge_instance"
  }
}
output "ec2_public_ips" {
  value = aws_instance.my_ec2_instance[*].public_ip
}
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "terraweek-challenge-s3bucket-2301"
  tags = {
    Name = "terraweek-challenge-s3bucket-2301"
    Envieonment = "dev"
  }
}
