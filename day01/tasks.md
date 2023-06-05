# TerraWeek Day 1

## Day 1: Introduction to Terraform and Terraform Basics

- What is Terraform and how can it help us manage infrastructure as code?

Answers : Terraform is HashiCorp's infrastructure as a code tool which let's us define resources & infrastructure in human readble  declarative configuration files and manages infrastructure lifecycle .

    Declarative Configuration: Terraform allows us to define user infrastructure resources and their dependencies using a declarative configuration language called HashiCorp Configuration Language (HCL). This configuration file represents usr desired infrastructure state, and Terraform automatically figures out how to create, update, or destroy resources to match that state.

    Infrastructure Provisioning: With Terraform, we can provision infrastructure resources across various cloud providers (such as AWS, Azure, Google Cloud Platform) and even on-premises environments. Terraform handles the resource creation process as well. 

    Version Control: By representing usr infrastructure as code, us can track changes to usr infrastructure over time using version control systems like Git. Terraform configurations can be stored in a repository, enabling collaboration, code reviews, and the ability to roll back or apply specific versions of usr infrastructure.

    Infrastructure as Code Paradigm: Terraform embraces the Infrastructure as Code paradigm, which means us can treat usr infrastructure configurations as software. This allows us to apply software engineering principles such as modularity, reusability, and testing to usr infrastructure code. us can break down usr infrastructure into reusable modules, define variables and input parameters, and leverage conditionals and loops to create dynamic configurations.

    Infrastructure State Management: Terraform maintains a state file that keeps track of the resources it manages. This state file represents the current state of usr infrastructure and is used to plan and execute changes. 

    Immutable Infrastructure: Terraform encourages the concept of immutable infrastructure, where changes are made by creating new resources instead of modifying existing ones.

    Dependency Management: Terraform allows us to define dependencies between resources explicitly. This ensures that resources are created or modified in the correct order to satisfy any dependencies. 

- Why do we need Terraform and how does it simplify infrastructure provisioning?

Answer :     

    Infrastructure Abstraction: Infrastructure provisioning involves interacting with various cloud providers and services, each with its own API, command-line tools, and configuration formats. Terraform abstracts away these differences by providing a unified language and framework to define and manage infrastructure resources. 

    Declarative Configuration: With Terraform, you define your desired infrastructure state using a declarative configuration language (HCL). Instead of scripting imperative instructions for creating and modifying resources, you describe the desired end state of your infrastructure. 

    Automation and Consistency: Terraform allows you to automate the provisioning process. Once you define your infrastructure configuration, Terraform can create, modify, or destroy resources automatically. This automation eliminates the need for manual intervention and ensures consistent provisioning across different environments.

    Plan and Preview Changes: Terraform provides a planning phase where it analyzes your infrastructure configuration and generates an execution plan. This plan shows you the changes Terraform will apply to your infrastructure resources, such as creating new resources, modifying existing ones, or destroying resources. The ability to preview and review changes before applying them simplifies infrastructure management by allowing you to verify the impact of changes and catch potential issues early on.

    Idempotent Operations: Terraform performs idempotent operations, which means running the same configuration multiple times results in a consistent infrastructure state.

    Infrastructure State Management: Terraform maintains a state file that tracks the current state of your infrastructure. 

    Ecosystem and Community: Terraform has a thriving ecosystem and a large community that contributes modules, plugins, and best practices.

- How can us install Terraform and set up the environment for AWS, Azure, or GCP?

Answer : Install Terraform on AWS Cloud steps :: >>>>


## installed the gnupg, software-properties-common, and curl packages

Step 1 : launch an ec2 instance > select your instance & connect > launch aws cli and command ::
          sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

## Install the HashiCorp GPG key.

Step 2 : wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

## Verify the key's fingerprint.

step 3 : gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint


## Download the package information from HashiCorp.

step 4 : echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

## Install Terraform from the new repository.
step 5 : sudo apt update && sudo apt-get install terraform 

- Explain the important terminologies of Terraform with the example at least (5 crucial terminologies).
Answer :    

 Provider: A provider in Terraform is responsible for interacting with a specific infrastructure provider, such as AWS, Azure, or Google Cloud Platform. Providers handle the API interactions and resource management for their respective platforms. 

example of using the AWS provider:
---------------------
provider "aws" {
  region = "us-west-2"
}
----------------------

Note : ws provider is specified, and the region parameter is set to "us-west-2" for the AWS resources to be created in the US West (Oregon) region.

    Resource: A resource represents an infrastructure object, such as an EC2 instance, S3 bucket, or VPC, that Terraform manages within an infrastructure provider. Resources are defined in Terraform configurations and can be created, modified, or destroyed by Terraform. example of defining an AWS EC2 instance resource:

-----------------------------------------

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
}
-----------------------------------------

Note : EC2 instance resource is defined using the aws_instance resource type. The ami parameter specifies the Amazon Machine Image (AMI) ID, and the instance_type parameter defines the instance type as "t2.micro"

    Module: A module is a reusable unit of Terraform configuration that encapsulates a set of resources and their dependencies. Modules enable code reuse, improve organization, and promote modularity in Terraform configurations. 
    
    example of using a module to create an AWS VPC:

--------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  
  cidr = "10.0.0.0/16"
}
----------------------------------------------
Variable: Variables in Terraform are placeholders that allow you to parameterize your configurations.

-----------------------------------------
variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  region        = var.region
}
------------------------------------------

Note  in this example, the region variable is defined with a default value of "us-west-2". The aws_instance resource uses var.region to reference the value of the region variable.

Output: Outputs in Terraform allow you to define values that are exposed after provisioning infrastructure. 

-----------------------------------------
resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
}

output "instance_ip" {
  value = aws_instance.example.private_ip
}
-------------------------------------------

Note : In this example, the instance_ip output is defined to expose the private IP address of the created AWS instance. The value parameter specifies the value to be displayed as the output.
