output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_a_id" {
  value = module.subnets.subnet_a_id
}

output "subnet_bc_id" {
  value = module.subnets.subnet_bc_id
}

output "sg_a" {
  value = module.sg.sg_a
}

output "sg_b" {
  value = module.sg.sg_b
}

output "sg_c" {
  value = module.sg.sg_c
}