provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  key_name      = "Akosuakeypem.pem"

  vpc_security_group_ids = ["sg-001ab1d59b4cfd130"]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Welcome to AWS CloudStart Youth 2025!" > /var/www/html/index.html
  EOF

  tags = {
    Name = "ApacheWebServer"
  }
}