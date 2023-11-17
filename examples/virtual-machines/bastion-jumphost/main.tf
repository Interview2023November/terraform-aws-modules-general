resource "aws_instance" "bastion" {
  ami                    = "ami-0d5d9d301c853a04a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  key_name               = var.key_pair_name

  associate_public_ip_address = true
}

resource "aws_instance" "backend" {
  ami                    = "ami-0d5d9d301c853a04a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  key_name               = var.key_pair_name

  associate_public_ip_address = false
}

resource "aws_security_group" "ssh_access" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}