resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address

  #ts:skip=AC_AWS_0480 Skip detailed monitoring scan for now as we have enabled as the default
  monitoring = var.monitoring

  metadata_options {
    # Don't allow IMDSV1 to be used
    http_tokens = "required"
  }

  user_data = var.user_data

  tags = {
    server-type = "bastion"
  }
}
