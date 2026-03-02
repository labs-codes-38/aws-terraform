# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
}

# NAT Gateway (uniquement pour le subnet A)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = var.subnet_a_id
  allocation_id = aws_eip.nat_eip.id
}

# Route table : Subnet A → Internet OK
resource "aws_route_table" "rt_a" {
  vpc_id = var.vpc_id
}

resource "aws_route" "rt_a_default" {
  route_table_id         = aws_route_table.rt_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "assoc_a" {
  route_table_id = aws_route_table.rt_a.id
  subnet_id      = var.subnet_a_id
}

# Route table : Subnet BC → pas d'Internet
resource "aws_route_table" "rt_bc" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "assoc_bc" {
  route_table_id = aws_route_table.rt_bc.id
  subnet_id      = var.subnet_bc_id
}