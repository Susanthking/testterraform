variable "vpc_id" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}

resource "aws_eip" "nat" {
  count = 2
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = var.public_subnet_1
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat[1].id
  subnet_id     = var.public_subnet_2
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = var.public_subnet_1
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = var.public_subnet_2
  route_table_id = aws_route_table.private.id
}

output "nat_gateway_ids" {
  value = [aws_nat_gateway.nat_gateway_1.id, aws_nat_gateway.nat_gateway_2.id]
}

