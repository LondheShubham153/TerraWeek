
resource "aws_instance" "aws_ec2_test" {
	        
        ami = "ami-053b0d53c279acc90"
        instance_type = "t2.micro"
        tags = {
     Name = "test-instance"
  }
}
