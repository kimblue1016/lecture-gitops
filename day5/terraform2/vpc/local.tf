locals {
	
	name = join("-", [
		local.tags.Project, local.tags.Region, local.tags.Application
	])
	
	tags = {
		Managed     = "terraform"
		Region      = "ane2"
		Project     = "study"
		Environment = "prod"
		Application = "hub"
	}
	
	region   = "ap-northeast-2"
	vpc_cidr = "10.0.0.0/16"
	azs      = ["ap-northeast-2a", "ap-northeast-2c"]
	az_count = length(local.azs)
	#slice(data.aws_availability_zones.available.names, 0, local.az_count)
}