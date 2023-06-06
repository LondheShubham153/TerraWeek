# TerraWeek Day 1

## Task 1: Familiarize yourself with HCL syntax used in Terraform
- Learn about HCL blocks, parameters, and arguments
- Explore the different types of resources and data sources available in Terraform

Terraform is an infrastructure as code (IaC) tool that allows you to define and provision infrastructure resources using declarative configuration files. The configuration language used by Terraform is called HashiCorp Configuration Language (HCL). In this response, I will provide an overview of the HCL syntax used in Terraform.

Comments:

Single-line comments start with a '#' character.

Multi-line comments are enclosed between '/' and '/'.

Blocks:

Configuration is organized into blocks, which are defined using braces '{ }'.

Each block represents a resource, data source, provider, or module.

Block type is specified as the first element inside the braces.

Example:
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

Attributes:

Inside a block, attributes are defined using the "key = value" syntax.

Each attribute is on a separate line.

String values can be written without quotes.

Example:

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}


Variables:

Variables allow you to parameterize your configuration.

They are defined using the "variable" block.

Example:

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}


Expressions:

HCL supports expressions for dynamic values.

Expressions are enclosed in "${ }".

Example:

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "${var.instance_type}"
}


Functions:

HCL provides built-in functions for manipulating values.

Functions are called using the "function_name(arguments)" syntax.

Example:

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "${lower(var.instance_type)}"
}


## Task 2: Understand variables, data types, and expressions in HCL
- Create a variables.tf file and define a variable
- Use the variable in a main.tf file to create a "local_file" resource


variable "TerraW" {
        description = "Name of the instance to be created"
        default = "TerraWeek"
}

here the variable name is TerraW where i have defined description and default value for automation .

# Define variables
variable "file_content" {
  type    = string
  default = "This is the content of the file."
}

# Resource block for local_file
resource "local_file" "example" {
  filename = "/path/to/output/file.txt"
  content  = var.file_content
}

In this example:

    The variable block defines a variable named file_content of type string.
    The local_file resource block creates a local file using the filename argument to specify the output file's path and the content argument to set the content of the file to the value of the file_content variable.

we can customize the configuration by providing a different default value for the file_content variable or adjusting the filename argument to specify the desired output file path.

Remember to replace /path/to/output/file.txt with the actual path where you want to create the local file.

That is how to use a variable to dynamically populate the content of a local_file resource in Terraform.





## Task 3: Practice writing Terraform configurations using HCL syntax
- Add required_providers to your configuration, such as Docker or AWS
- Test your configuration using the Terraform CLI and make any necessary adjustments
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.60.0"
    }
  }
}

provider "docker" {
}

provider "aws" {
  
}

In this example:

    The required_providers block is added at the beginning of the configuration file, within the terraform block.
    Inside the required_providers block, each provider is specified with a unique identifier (e.g., docker, aws).
    For each provider, the source attribute specifies the provider's namespace and the version attribute specifies the desired version.

After defining the required_providers block, we can then configure each provider separately using the respective provider blocks, providing any necessary configuration parameters specific to each provider.

we need to replace the version numbers (2.15.0 for Docker and 3.60.0 for AWS) with the desired versions that we want to use .


Attach code snippets and steps wherever necessary and post your learnings on LinkedIn
Feel Free to reach out to any of the TWS Community Builders / Leaders
Watch this 👉 https://youtu.be/kqJIKjkJ1Lo

# Happy Learning🎉🚀
