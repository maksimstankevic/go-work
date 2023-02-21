module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "go-work-vpc"
  cidr = var.vpc_cidr_range

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_dns_hostnames = true
  single_nat_gateway = true
  map_public_ip_on_launch = false

  tags = {
    Terraform = "true"
    Environment = "prod"
  }
}