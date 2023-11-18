locals {
  database_port = 3306
}

module "vpc" {
  source = "../../../modules/networking/vpc-3-tier"

  name        = var.name
  environment = "example"
}

resource "aws_security_group" "nat" {
  name   = "${var.name}-nat-sg"
  vpc_id = module.vpc.id

  tags = {
    Name        = "${var.name}-nat-sg"
    Environment = "example"
  }
}

resource "aws_security_group" "lb" {
  name   = "${var.name}-lb-sg"
  vpc_id = module.vpc.id

  tags = {
    Name        = "${var.name}-lb-sg"
    Environment = "example"
  }
}

module "nat_gateway" {
  source = "../../../modules/networking/nat-gateway"

  name        = var.name
  environment = "example"
  subnet_id   = module.vpc.dmz_public_subnet_ids[0]
}

resource "aws_route" "private_egress" {
  route_table_id         = module.vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.nat_gateway.id
}

module "load_balancer" {
  source = "../../../modules/networking/load-balancer"

  name            = var.name
  environment     = "example"
  subnets         = module.vpc.dmz_public_subnet_ids
  vpc_id          = module.vpc.id
  target_port     = var.webserver_port
  security_groups = [aws_security_group.lb.id]
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_traffic_to_lb" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.lb_port
  ip_protocol = "tcp"
  to_port     = var.lb_port
}
