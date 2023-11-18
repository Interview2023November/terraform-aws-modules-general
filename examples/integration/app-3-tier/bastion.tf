module "bastion" {
  source = "../../../modules/virtual-machines/bastion"

  name                   =  "${var.name}-bastion"
  ami                    = "ami-0ca34949803acc44e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name
  subnet_id              = module.vpc.dmz_public_subnet_ids[0]

  associate_public_ip_address = true
}

resource "aws_security_group" "bastion" {
  name   = "${var.name}-bastion-sg"
  vpc_id = module.vpc.id

  tags = {
    Name        = "${var.name}-bastion-sg"
    Environment = "example"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_traffic_to_bastion" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.ssh_port
  ip_protocol = "tcp"
  to_port     = var.ssh_port
}

resource "aws_vpc_security_group_egress_rule" "allow_bastion_access_to_webserver" {
  security_group_id = aws_security_group.bastion.id

  referenced_security_group_id = aws_security_group.app.id
  from_port   = var.ssh_port
  ip_protocol = "tcp"
  to_port     = var.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_webserver_access_from_bastion" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.bastion.id
  from_port   = var.ssh_port
  ip_protocol = "tcp"
  to_port     = var.ssh_port
}
