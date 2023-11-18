resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id

  #ts:skip=AC_AWS_0480 Skip detailed monitoring scan for now as we have enabled as the default
  monitoring = var.monitoring

  # Currently if we want ssh to function without heavier AMI customization we have to live with IMDSV1
  # See https://stackoverflow.com/questions/65035324/unable-to-ssh-into-aws-ec2-instance-with-instance-metadata-turned-off
  #ts:skip=AC-AWS-NS-IN-M-1172
  # metadata_options {
  #   # Don't allow IMDSV1 to be used
  #   http_tokens   = "required"
  # }

  user_data = var.user_data

  tags = {
    Name        = var.name
    server-type = "bastion"
  }
}
