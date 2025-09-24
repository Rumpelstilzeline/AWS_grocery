data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf -y update
    dnf -y install httpd
    systemctl enable httpd
    echo "Hello from Terraform on $(hostname)" > /var/www/html/index.html
    systemctl start httpd
  EOF

  tags = {
    Name = "tf-ec2-web"
  }
}
