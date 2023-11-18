data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_subnet" "this" {
  count = length(var.cidrs)

  vpc_id            = var.vpc_id
  cidr_block        = var.cidrs[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]

  tags = {
    Name        = "${var.name}-subnet"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "this" {
  count = length(var.cidrs)

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = var.route_table_id
}
