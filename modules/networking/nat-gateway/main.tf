resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name        = "${var.name}-nat-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.subnet_id

  tags = {
    Name        = "${var.name}-nat"
    Environment = var.environment
  }
}
