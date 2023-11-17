module "webserver" {
  source = "../../../modules/virtual-machines/webserver"

  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  # Detailed monitoring is not needed in an example setting
  monitoring = false

  user_data = <<EOF
#!/bin/bash
/home/ubuntu/i_am_a_webserver.sh fake 1234 fake fake
EOF
}

resource "aws_security_group" "instance" {
  #ts:skip=AC_AWS_0242 Skip internal port requirement for example resource
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
