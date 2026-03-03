terraform {
  required_version = ">= 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  }

module "vpc" {
  source = "./modules/vpc"
  cidr   = var.vpc_cidr
}

module "subnets" {
  source = "./modules/subnets"

  vpc_id         = module.vpc.vpc_id
  subnet_a_cidr  = var.subnet_a_cidr
  subnet_bc_cidr = var.subnet_bc_cidr
}

module "routing" {
  source = "./modules/routing"

  vpc_id       = module.vpc.vpc_id
  subnet_a_id  = module.subnets.subnet_a_id
  subnet_bc_id = module.subnets.subnet_bc_id
}

module "sg" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}