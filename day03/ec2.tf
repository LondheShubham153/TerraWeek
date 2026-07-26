data "aws_ami" "ubuntu" {
    owners      = [var.aws_ami_owners]
    most_recent = true

    filter {
        name   = "name"
        values = [var.aws_ami_image]
    }

    filter {
        name   = "state"
        values = ["available"]
    }
}

resource "aws_key_pair" "terraweek_key" {
    key_name   = var.aws_private_key_pair_name
    public_key = file(var.aws_public_key_pair_name)
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_terraweek_sg" {
    name        = var.aws_sg_name
    description = var.aws_sg_description
    vpc_id      = aws_default_vpc.default.id

    ingress {
        description = "Allow access to SSH port 22"
        from_port   = 22
        to_port     = 22
        protocol    = var.ssh_protocol
        cidr_blocks = [var.ssh_cidr]
    }

    ingress {
        description = "Allow access to HTTP port 80"
        from_port   = 80
        to_port     = 80
        protocol    = var.http_protocol
        cidr_blocks = [var.http_cidr]
    }

    ingress {
        description = "Allow access to HTTPS port 443"
        from_port   = 443
        to_port     = 443
        protocol    = var.https_protocol
        cidr_blocks = [var.https_cidr]
    }

    egress {
        description      = "allow all outgoing traffic"
        from_port        = 0
        to_port          = 0
        protocol         = var.outgoing_protocol
        cidr_blocks      = [var.outgoing_cidr]
        ipv6_cidr_blocks = [var.outgoing_ipv6_cidr]
    }

    tags = {
        Name = var.aws_sg_name
    }
}

resource "aws_instance" "my_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.aws_instance_type
  key_name        = aws_key_pair.terraweek_key.key_name
  security_groups = [aws_security_group.my_terraweek_sg.name]

  root_block_device {
    volume_size = var.aws_instance_volume_size
    volume_type = var.aws_instance_volume_type
  }

  tags = {
    Name = var.aws_instance_name
  }

  # Provisioner to install nginx on the instance after it's created
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    # Use the private key for SSH authentication
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.aws_private_key_pair_name)
      host        = self.public_ip
    }
  }

  # Lifecycle management configuration
  lifecycle {
    create_before_destroy = true     # Create the new instance before destroying the old one
    prevent_destroy        = false   # Allow the resource to be destroyed
    ignore_changes         = [tags]   # Ignore changes to the tags
  }
}

