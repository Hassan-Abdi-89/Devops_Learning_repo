provider "aws" {
  region = var.region
}
# Get latest Ubuntu 22.04 LTS AMI (Canonical official)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "state"
    values = ["available"]
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
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#EC2 Instance
resource "aws_instance" "wordpress" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids =  [aws_security_group.wordpress_sg.id]

  associate_public_ip_address = true

  user_data = file("user-data.sh")
  tags = {
    Name = "wordpress-server"
  }
}