provider "aws" {
  region = var.region
}
#Get latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amazn2-ami-hvm-*"]
    }
}

# Security Group
resource "aws_security_group" "wordpress_sg" {
  name = "wordpress-sg"

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

}
#EC2 Instance
resource "aws_instance" "wordpress" {
  ami = data.aws_ami.amazon_linux
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [aws_security_group.wordpress_sg]
  user_data = file("user-data.sh")
  tags = {
    Name = "wordpress-server"
  }
}