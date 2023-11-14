# TerraWeek Day 1

## Day 1: Introduction to Terraform and Terraform Basics

- What is Terraform and how can it help you manage infrastructure as code?
IAC means the writing the code to provision, manage and deploy it , terraform is open source tool using hashicorp language used to manage, update, delete the infra using code only i.e infrastructure is created using code only.


- Why do we need Terraform and how does it simplify infrastructure provisioning?
It's used for creating the infrastructure on multiple cloud providers like aws, azure, gcp.
Deploying, managing, and orchestrating multi-cloud environments can be a huge challenge for DevOps teams.Terraform is Infrastructure-as-Code (IaC) as it relates to AWS.

- How can you install Terraform and set up the environment for AWS, Azure, or GCP?
Download the terraform into hashicrop side and install the plugin in editor.

- Explain the important terminologies of Terraform with the example at least (5 crucial terminologies).
1. Providers : we need to terraform init , this commands download the plugin we need for providers. Provides are basically cloud like aws. Init command initialize the working dir containing terraform config file.
2. Terraform plan : Declare the resources, used to create execution plan
3. Terraform validate : Verify the config is syntactically valid. Do not check the formatting.
			Sometime there is same model declared multiple time so validate 
			Check these.
4. Terraform apply : Used to apply the changes
5. Terraform destroy  : 
 	Terraform destroy-target <resource-type>.<resource-name>

Attach code snippets and steps wherever necessary and post your learnings on LinkedIn

Feel Free to reach out to any of the TWS Community Builders / Leaders

Watch this [Reference Video](https://www.youtube.com/live/965CaSveIEI?feature=share)

Happy Learning 
