terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.1"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project     = var.project
  environment = var.environment

  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
}

module "asg" {
  source = "./modules/asg"

  project        = var.project
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  vpc_subnets_id = module.vpc.vpc_subnets_id
}
