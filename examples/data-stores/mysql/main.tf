module "database_server" {
  source = "../../../modules/data-stores/mysql"

  name                   = var.name
  db_username            = var.db_username
  db_password            = var.db_password
  db_name                = var.db_name
  instance_class         = var.instance_class
  port                   = var.port
  # These options make testing and manual work in an example setting convenient
  # For prod environments we'd want to consider policy tools like OPA to prevent them from being configured
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_instance.id]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "db_instance" {
  name   = var.name
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name        = var.name
    Environment = "example"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.name
  subnet_ids = data.aws_subnets.all.ids

  tags = {
    Name        = var.name
    Environment = "example"
  }
}

resource "aws_security_group_rule" "allow_db_access" {
  #ts:skip=AC_AWS_0276 Skip unknown port requirement for example resource
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = aws_security_group.db_instance.id
  cidr_blocks       = ["0.0.0.0/0"]
}
