output "vpc_id" {
	description = "The ID of the VPC"
	value       = module.vpc.vpc_id
}

output "private_subnets" {
	description = "List of IDs of private subnets"
	value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
	description = "List of cidr_blocks of private subnets"
	value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
	description = "List of IDs of public subnets"
	value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
	description = "List of cidr_blocks of public subnets"
	value       = module.vpc.public_subnets_cidr_blocks
}

output "database_subnets" {
	description = "List of IDs of database subnets"
	value       = module.vpc.database_subnets
}

output "database_subnets_cidr_blocks" {
	description = "List of cidr_blocks of database subnets"
	value       = module.vpc.database_subnets_cidr_blocks
}

output "database_subnet_group" {
	description = "ID of database subnet group"
	value       = module.vpc.database_subnet_group
}

output "database_subnet_group_name" {
	description = "Name of database subnet group"
	value       = module.vpc.database_subnet_group_name
}
