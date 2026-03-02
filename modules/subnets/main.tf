resource "aws_subnet" "subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_a_cidr
}

resource "aws_subnet" "subnet_bc" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_bc_cidr
}