module "database_server" {
  source = "../../../modules/data-stores/mysql"

  name           = "${var.name}-db"
  db_username    = var.db_username
  db_password    = var.db_password
  db_name        = var.db_name
  instance_class = var.instance_class
  port           = var.db_port
  # Skipping snapshots to make testing easier.
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db.id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-db-subnets"
  subnet_ids = module.vpc.back_end_private_subnet_ids

  tags = {
    Name        = "${var.name}-db-subnets"
    Environment = "example"
  }
}

resource "aws_security_group" "db" {
  name   = "${var.name}-db-sg"
  vpc_id = module.vpc.id

  tags = {
    Name        = "${var.name}-db-sg"
    Environment = "example"
  }
}

resource "aws_security_group" "app" {
  name   = "${var.name}-app-sg"
  vpc_id = module.vpc.id

  tags = {
    Name        = "${var.name}-app-sg"
    Environment = "example"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_db_access_from_private_front_end" {
  security_group_id = aws_security_group.db.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}

resource "aws_vpc_security_group_egress_rule" "allow_private_front_end_access_to_db" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.db.id
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}

module "webserver" {
  source = "../../../modules/virtual-machines/webserver"

  name                   = "${var.name}-webserver"
  ami                    = var.webserver_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  # Detailed monitoring is not needed in an example setting
  monitoring = false
  subnet_id  = module.vpc.front_end_private_subnet_id

  user_data = <<EOF
#!/bin/bash
/home/ubuntu/i_am_a_webserver.sh ${module.database_server.address} ${module.database_server.port} ${var.db_username} ${var.db_password}
EOF
}

resource "aws_vpc_security_group_ingress_rule" "allow_webserver_access_from_lb" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.lb.id
  from_port                    = var.webserver_port
  ip_protocol                  = "tcp"
  to_port                      = var.webserver_port
}

resource "aws_vpc_security_group_egress_rule" "allow_lb_access_to_webserver" {
  security_group_id = aws_security_group.lb.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.webserver_port
  ip_protocol                  = "tcp"
  to_port                      = var.webserver_port
}

resource "aws_vpc_security_group_egress_rule" "allow_webserver_access_to_nat" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_db_access_to_nat" {
  security_group_id = aws_security_group.db.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_lb_target_group_attachment" "webserver" {
  target_group_arn = module.load_balancer.target_group_arn
  target_id        = module.webserver.id
  port             = var.webserver_port
}
