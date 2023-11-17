resource "aws_instance" "webserver" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  monitoring             = var.monitoring

  metadata_options {
    # Don't allow IMDSV1 to be used
    http_tokens = "required"
  }
  
  user_data = var.user_data

  tags = {
    server-type = "app"
  }
}
