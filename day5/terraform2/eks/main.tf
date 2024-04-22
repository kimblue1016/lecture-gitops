data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

data "aws_subnets" "private" {
	filter {
		name   = "vpc-id"
		values = [local.vpc_id]
	}
	
	tags = {
		"kubernetes.io/role/internal-elb" = "1"
	}
}

provider "helm" {
	kubernetes {
		host                   = module.eks.cluster_endpoint
		cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
		
		exec {
			api_version = "client.authentication.k8s.io/v1beta1"
			command     = "aws"
			args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.region]
		}
	}
}

provider "kubernetes" {
	host                   = module.eks.cluster_endpoint
	cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
	
	exec {
		api_version = "client.authentication.k8s.io/v1beta1"
		command     = "aws"
		args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.region]
	}
}

module "gitops_bridge_bootstrap" {
	source = "gitops-bridge-dev/gitops-bridge/helm"
	
	cluster = {
		metadata = local.addons_metadata
		addons   = local.addons
	}
	apps = local.argocd_apps
}

module "eks_blueprints_addons" {
	source  = "aws-ia/eks-blueprints-addons/aws"
	version = "~> 1.0"
	
	cluster_name      = module.eks.cluster_name
	cluster_endpoint  = module.eks.cluster_endpoint
	cluster_version   = module.eks.cluster_version
	oidc_provider_arn = module.eks.oidc_provider_arn
	
	create_kubernetes_resources = false
	
	enable_cert_manager                 = local.aws_addons.enable_cert_manager
	enable_aws_efs_csi_driver           = local.aws_addons.enable_aws_efs_csi_driver
	enable_aws_fsx_csi_driver           = local.aws_addons.enable_aws_fsx_csi_driver
	enable_aws_cloudwatch_metrics       = local.aws_addons.enable_aws_cloudwatch_metrics
	enable_aws_privateca_issuer         = local.aws_addons.enable_aws_privateca_issuer
	enable_cluster_autoscaler           = local.aws_addons.enable_cluster_autoscaler
	enable_external_dns                 = local.aws_addons.enable_external_dns
	enable_external_secrets             = local.aws_addons.enable_external_secrets
	enable_aws_load_balancer_controller = local.aws_addons.enable_aws_load_balancer_controller
	enable_fargate_fluentbit            = local.aws_addons.enable_fargate_fluentbit
	enable_aws_for_fluentbit            = local.aws_addons.enable_aws_for_fluentbit
	enable_aws_node_termination_handler = local.aws_addons.enable_aws_node_termination_handler
	enable_karpenter                    = local.aws_addons.enable_karpenter
	enable_velero                       = local.aws_addons.enable_velero
	enable_aws_gateway_api_controller   = local.aws_addons.enable_aws_gateway_api_controller
	
	external_dns_route53_zone_arns = [local.route53_zone_arn]
	
	tags = local.tags
}


module "eks" {
	source  = "terraform-aws-modules/eks/aws"
	version = "~> 19.13"
	
	cluster_name                   = "${local.name}-eks"
	cluster_version                = local.cluster_version
	cluster_endpoint_public_access = true
	
	vpc_id     = local.vpc_id
	subnet_ids = toset(data.aws_subnets.private.ids)
	
	eks_managed_node_groups = {
		initial = {
			instance_types = ["t3.medium"]
			
			min_size     = 2
			max_size     = 2
			desired_size = 2
		}
	}
	
	cluster_addons = {
		vpc-cni = {
			before_compute = true
			most_recent    = true
			configuration_values = jsonencode({
				env = {
					ENABLE_PREFIX_DELEGATION = "true"
					WARM_PREFIX_TARGET       = "1"
				}
			})
		}
	}
	
	tags = local.tags
}

data "aws_route53_zone" "this" {
	count        = local.enable_ingress ? 1 : 0
	name         = local.domain_name
	private_zone = local.is_route53_private_zone
}

resource "aws_acm_certificate" "cert" {
	count             = local.enable_ingress ? 1 : 0
	domain_name       = "${local.argocd_subdomain}.${local.domain_name}"
	validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
	count           = local.enable_ingress ? 1 : 0
	zone_id         = data.aws_route53_zone.this[0].zone_id
	name            = tolist(aws_acm_certificate.cert[0].domain_validation_options)[0].resource_record_name
	type            = tolist(aws_acm_certificate.cert[0].domain_validation_options)[0].resource_record_type
	records         = [tolist(aws_acm_certificate.cert[0].domain_validation_options)[0].resource_record_value]
	ttl             = 60
	allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
	count                   = local.enable_ingress ? 1 : 0
	certificate_arn         = aws_acm_certificate.cert[0].arn
	validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}