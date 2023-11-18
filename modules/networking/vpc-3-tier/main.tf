resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.name}-vpc"
    Environment = var.environment
  }
}

# We will assume all VPCs instantiated with this module will have *some* internet connectivity
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-public-rtb"
    Environment = var.environment
  }
}

module "dmz_public_subnets" {
  source = "./subnet-tier"

  name           = "${var.name}-dmz"
  environment    = var.environment
  cidrs          = [var.dmz_public_cidr_a, var.dmz_public_cidr_b]
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-private-rtb"
    Environment = var.environment
  }
}

module "front_end_private_subnet" {
  source = "./subnet-tier"

  name           = "${var.name}-fe"
  environment    = var.environment
  cidrs          = [var.front_end_private_cidr]
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.private.id
}

module "back_end_private_subnets" {
  source = "./subnet-tier"

  name           = "${var.name}-bea"
  environment    = var.environment
  cidrs          = [var.back_end_private_cidr_a, var.back_end_private_cidr_b]
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
