# TerraWeek Day 1

### **Day 1: Introduction to Terraform and Terraform Basics**

#### **What is Terraform, and how can it help you manage Infrastructure as Code?**
Terraform is an open-source tool by HashiCorp that allows you to define, manage, and provision infrastructure as code (IaC). It uses a declarative configuration language, HCL (HashiCorp Configuration Language), to describe the desired state of infrastructure. By applying these configurations, Terraform ensures that the actual infrastructure matches the desired state.


Key benefits of Terraform:

- **Consistency:** The same configurations can be reused across environments (e.g., dev, staging, production).
- **Version Control:** Infrastructure definitions are stored in source control systems like Git.
- **Automation:** Removes the need for manual intervention during resource creation.
- **Cloud-Agnostic:** Supports multiple cloud providers like AWS, Azure, GCP, and even on-prem solutions.

---

#### **Why do we need Terraform, and how does it simplify infrastructure provisioning?**
1. **Eliminates Manual Effort:** Automates the provisioning, scaling, and configuration of resources.
2. **Infrastructure as Code:** Maintains infrastructure as code for better tracking, auditing, and collaboration.
3. **Cross-Cloud Compatibility:** Provides a unified approach to managing multi-cloud and hybrid environments.
4. **Dependency Management:** Automatically understands and manages dependencies between resources.
5. **Cost and Time Efficiency:** Reduces operational overhead and human error, enabling rapid infrastructure changes.

---

#### **How Can You Install Terraform and Set Up the Environment for AWS?**

#### **Before You Begin: Create an EC2 Instance for Running Commands**

To execute the following commands in an isolated environment, create an Ubuntu EC2 instance using AWS Management Console:

##### **Launch an EC2 Instance:**

1. Go to the **EC2 Dashboard** on AWS.
2. Click **Launch Instance**.
3. Configure:
    - **Name:** Terraform-Setup
    - **AMI:** Ubuntu Server 22.04 LTS
    - **Instance Type:** t2.micro (free tier eligible)
    - **Key Pair:** Create or select an existing key pair.
    - **Network Settings:** Allow SSH traffic (port 22) from your IP address.
    - **Storage:** Keep the default 8 GiB or adjust as needed.

##### **Connect to the Instance:**

Use an SSH client or AWS CloudShell to connect:

```bash
ssh -i "your-key-pair.pem" ubuntu@<EC2-Public-IP>
```

##### **Update the Instance:**

Run the following commands after connecting:

```bash
sudo apt update && sudo apt upgrade -y
```

Now proceed with the installation of Terraform and setting up AWS credentials.


##### 1. **Install Terraform on Ubuntu:**

To install Terraform on Ubuntu, follow these steps:

- **Add the HashiCorp GPG Key and Repository:**

  ```bash
  wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  ```
  
- **Update the Package List and Install Terraform:**

  ```bash
  sudo apt update && sudo apt install terraform
  ```

- **Verify Installation:**

  Confirm that Terraform is installed correctly by checking its version:

  ```bash
  terraform version
  ```



##### 2. **Set Up Terraform for AWS:**

- **Create an IAM User in AWS:**

  - Go to the **IAM Management Console** in AWS.
  - Create a new IAM user with **programmatic access**.
  - Attach the necessary policies (e.g., `AdministratorAccess` or policies tailored to your use case).
  - Note down the **Access Key ID** and **Secret Access Key**.

- **Install the AWS CLI:**

  Install the AWS CLI to configure credentials:

  First install unzip using : `sudo apt install unzip`
  
  ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
  ```

- **Configure AWS CLI Credentials:**

  Run the following command and enter your IAM user details:
  ```bash
  aws configure
  ```

  Provide:
  - **Access Key ID**
  - **Secret Access Key**
  - **Default region** (e.g., `us-east-1`)
  - Output format (default: `json`)


- **Verify AWS CLI Configuration:**

  Check your AWS CLI configuration:
  ```bash
  aws sts get-caller-identity
  ```

- **Use AWS as a Provider in Terraform:**
  Add the provider configuration to your Terraform `.tf` file:

    ```hcl
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "5.65.0"
        }
      }
    }

    provider "aws" {
      region = "us-east-1"
    }
    ```

With these steps, your environment is ready to manage AWS infrastructure using Terraform.


---


#### **Important Terminologies of Terraform**

1. **Provider:**

   - Defines the cloud service (e.g., AWS, Azure) or on-premises platform you are interacting with.

   - Example:

     ```hcl
     provider "aws" {
       region = "us-west-2"
     }
     ```

2. **Resource:**

   - A fundamental element (e.g., an EC2 instance, an S3 bucket) described in the Terraform configuration.

   - Example:

     ```hcl
     resource "aws_s3_bucket" "example" {
       bucket = "example-bucket"
       tags = {
            Name = "example-bucket"
       }
     }
     ```

3. **State:**

   - A file that tracks the current state of your infrastructure. It helps Terraform understand the desired state versus the actual state.

   - Example:

     Terraform generates a `terraform.tfstate` file during execution.


4. **Module:**

   - A reusable and logical grouping of resources defined in separate files or directories.

   - Example:

     ```hcl
     module "vpc" {
       source = "./modules/vpc"
       cidr   = "10.0.0.0/16"
     }
     ```

5. **Data Source:**

   - Allows fetching data from external sources (e.g., the details of an existing AWS AMI).

   - Example:
     ```hcl
     data "aws_ami" "ubuntu" {
       most_recent = true
       filter {
         name   = "name"
         values = ["ubuntu/images/*"]
       }
     }
     ```

These terminologies form the backbone of understanding and working with Terraform effectively!



Watch this [Reference Video](https://www.youtube.com/live/965CaSveIEI?feature=share)

