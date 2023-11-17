resource "aws_db_instance" "this" {
  identifier                          = var.name
  engine                              = "mysql"
  allocated_storage                   = var.allocated_Storage_gb
  backup_retention_period             = var.backup_retention_period
  instance_class                      = var.instance_class
  skip_final_snapshot                 = var.skip_final_snapshot
  db_name                             = var.db_name
  username                            = var.db_username
  password                            = var.db_password
  port                                = var.port
  publicly_accessible                 = var.publicly_accessible
  db_subnet_group_name                = var.db_subnet_group_name
  vpc_security_group_ids              = var.vpc_security_group_ids
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports

  tags = {
    Name = var.name
  }
}
