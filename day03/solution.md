# TerraWeek Day 3


### Task 1: **Create a Terraform configuration file to define a resource (AWS EC2 instance)**

The `main.tf` and `ec2.tf` files define the AWS EC2 instance along with necessary resources like security groups, key pairs, and AMI. Here's a breakdown:

- **AWS Provider Configuration**: 
  - The AWS provider is set up in `main.tf`, which specifies the region and version for the `aws` provider.
  
- **EC2 Instance**:
  - In `ec2.tf`, the resource `aws_instance.my_instance` defines an EC2 instance, referencing the latest Ubuntu AMI and configuring a security group (`aws_security_group.my_terraweek_sg`) and key pair (`aws_key_pair.terraweek_key`).

- **Security Group**: 
  - A security group is configured to allow SSH, HTTP, and HTTPS traffic, as specified in `ec2.tf`.

- **Provisioner**: 
  - A remote-exec provisioner is added to install Nginx on the EC2 instance once it's created. This is defined inside the `aws_instance.my_instance` resource block.

- **See the `main.tf` and `terraform.tf` for source code regarding this task**

---


### Task 2: **Check state files before running plan and apply commands & Use validate command**

- **State Files**: 
  - Terraform stores the state of your infrastructure in a state file (usually `terraform.tfstate`). This file tracks the resources you create and manage with Terraform. Before running `terraform plan` or `terraform apply`, it's essential to check this state file to ensure your infrastructure matches the current state.

  - State files before plan and apply : 
    
    ![task2.1](images/task2.1.png)

- **Validate Command**:
  - The `terraform validate` command checks for syntax errors and validates that the configuration files are correct and usable.

  **Commands to run**:
  ```bash
  terraform validate
  ```

  This command will output `Success! The configuration is valid.` if there are no issues.


  ![task2.2](images/task2.2.png)


  - Terraform plan :
    
    ![task2.3.1](images/task2.3.1.png)

    ![task2.3.2](images/task2.3.2.png)


  - Terraform apply : 

    ![task2.4.1](images/task2.4.1.png)

    ![task2.4.2](images/task2.4.2.png)

  
  - EC2 instance running successfully : 

    ![task2.5](images/task2.5.png)

---


### Task 3: **Add a provisioner to configure the resource after creation and use Terraform commands to apply and destroy**

A provisioner is already included in the `aws_instance.my_instance` resource block in `ec2.tf`, which installs and starts Nginx after the instance is created.

- **Provisioner Block**:
  ```hcl
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.aws_private_key_pair_name)
      host        = self.public_ip
    }
  }
  ```
  This block ensures that after the instance is created, Nginx is installed and started automatically.

  - Added Provisioner block to existing ec2.tf : 
    
    ![task3.1](images/task3.1.png)


- **Terraform Commands**:
- To apply changes and provision the EC2 instance, run:

    ```bash
    terraform apply --auto-approve
    ```

    - Terraform apply images: 

        ![task3.3.1](images/task3.3.1.png)

        ![task3.3.2](images/task3.3.2.png)

        ![task3.3.3](images/task3.3.3.png)

    
    - Nginx running successfully :

        ![task3.3.4](images/task3.3.4.png) 


- To destroy the resources (in this case, the EC2 instance), run:

    ```bash
    terraform destroy
    ```

    This will prompt you to confirm the deletion of the resources (type `yes` to proceed).

    - Terraform destroy images : 

        ![task3.2.1](images/task3.2.1.png)

        ![task3.2.2](images/task3.2.2.png)

---


### Task 4: **Add lifecycle management configurations to the configuration file**

The `lifecycle` block in the `aws_instance.my_instance` resource manages how Terraform handles resource creation, modification, and destruction. Here's a breakdown of the lifecycle configuration you provided:

```hcl
lifecycle {
  create_before_destroy = true     # Create the new instance before destroying the old one
  prevent_destroy        = false   # Allow the resource to be destroyed
  ignore_changes         = [tags]  # Ignore changes to the tags
}
```

- Added lifecycle block to existing ec2.tf : 
    
    ![task4.1](images/task4.1.png)


- **`create_before_destroy = true`**: 
  - This ensures that Terraform creates a new instance before destroying the old one. This is useful in situations where you don't want downtime while updating the instance.

- **`prevent_destroy = false`**: 
  - This allows the resource to be destroyed. Setting it to `true` would prevent the destruction of the resource, which can be useful for critical infrastructure.

  - what if I set  `prevent_destroy = true` ,this will cause error , you can see in below images

    ![task4.2.1](images/task4.2.1.png)

    ![task4.2.2](images/task4.2.2.png)

    ![task4.2.3](images/task4.2.3.png)   

  
- **`ignore_changes = [tags]`**: 
  - This instructs Terraform to ignore any changes to the `tags` attribute. If the tags are updated in the configuration or manually, Terraform will not attempt to modify the tags on the resource.

---


### Terraform Commands for Task 4:

- **Apply the Changes**:
  After modifying the lifecycle management block, you can run:
  ```bash
  terraform apply
  ```


---



### Summary of Terraform Commands:

1. **Validate Configuration**:
   ```bash
   terraform validate
   ```

2. **Initialize Terraform (if not done already)**:
   ```bash
   terraform init
   ```

3. **Plan Changes**:
   ```bash
   terraform plan
   ```

4. **Apply Changes**:
   ```bash
   terraform apply
   ```

   ```bash
   terraform apply --auto-approve
   ```

5. **Destroy Resources**:
   ```bash
   terraform destroy
   ```

