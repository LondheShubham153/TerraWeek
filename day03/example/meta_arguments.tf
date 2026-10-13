# =====================================================================
# Task 4 — Meta-arguments in action
# Kept in a separate file so main.tf (VPC + single EC2 web server)
# stays exactly as the base task, and these are clearly additive.
# =====================================================================

# --- for_each: named, stable resources (preferred over count when each
# instance has an identity you care about — here, "app" and "db" subnets) ---

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-private-${each.key}"
  }
}

# --- count: N identical, interchangeable resources (order doesn't matter,
# they're not individually named/tracked by identity) ---

resource "aws_instance" "worker" {
  count = var.extra_worker_count

  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "${var.name_prefix}-worker-${count.index}"
  }
}

# --- depends_on: explicit ordering ---
# Terraform already infers most dependencies from references (e.g. worker
# reads aws_subnet.public.id, so it implicitly waits for the subnet).
# depends_on is for the rare case where there's NO attribute reference to
# create that link — e.g. this null_resource doesn't read any attribute
# of aws_instance.web, but we still want it to run only after the web
# server exists.
resource "null_resource" "post_boot_check" {
  depends_on = [aws_instance.web]

  triggers = {
    instance_id = aws_instance.web.id
  }

  provisioner "local-exec" {
    command = "echo Web server ${aws_instance.web.id} is up, running post-boot check..."
  }
}

# --- lifecycle: create_before_destroy + ignore_changes ---
# (create_before_destroy is already on aws_instance.web in main.tf.
#  Adding ignore_changes there too, shown here as the snippet to merge in:)
#
# resource "aws_instance" "web" {
#   ...
#   lifecycle {
#     create_before_destroy = true
#     ignore_changes        = [tags["LastModified"]]
#   }
# }

# --- lifecycle: prevent_destroy ---
# A small S3 bucket just to demonstrate prevent_destroy safely.
# IMPORTANT: prevent_destroy blocks `terraform destroy` on this resource.
# Before your final cleanup at the end of Day 3, either remove this
# resource block or flip prevent_destroy to false, otherwise destroy
# will fail on purpose here.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "protected_demo" {
  bucket = "${var.name_prefix}-protected-${random_id.bucket_suffix.hex}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.name_prefix}-protected-demo"
  }
}
