module "ec2_instance" {
  source         = "./terraform-infra"
  ami_id         = "ami-0e9085e60087ce171"
  instance_type  = "t2.micro"
  instance_name  = "MyWebServer"
}
