module "bastion" {
  source = "../../../modules/virtual-machines/bastion"

  ami                    = "ami-0ca34949803acc44e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  key_name               = var.key_name

  associate_public_ip_address = true
}

resource "aws_instance" "backend" {
  #ts:skip=AC_AWS_0480 Skip detailed monitoring for example resource

  ami                    = "ami-0d5d9d301c853a04a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  key_name               = var.key_name

  associate_public_ip_address = false

  metadata_options {
    # Don't allow IMDSV1 to be used
    http_tokens = "required"
  }
}

resource "aws_security_group" "ssh_access" {
  #ts:skip=AC_AWS_0227 Skip unrestricted port requirement for example resource

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
