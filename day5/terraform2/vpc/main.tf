data "aws_availability_zones" "available" {}

module "vpc" {
	source = "terraform-aws-modules/vpc/aws"
	
	name = "${local.name}-vpc"
	cidr = local.vpc_cidr
	
	azs              = local.azs
	public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
	database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + local.az_count)]
	private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + (local.az_count * 2))]
	
	enable_nat_gateway = true
	single_nat_gateway = true
	
	public_subnet_tags = {
		"kubernetes.io/role/elb" = 1
	}
	
	private_subnet_tags = {
		"kubernetes.io/role/internal-elb" = 1
		"karpenter.sh/discovery"          = local.name
	}
	
	tags = merge({
		Resource = "vpc"
	}, local.tags)
}

