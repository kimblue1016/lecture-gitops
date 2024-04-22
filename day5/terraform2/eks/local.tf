locals {
	name = join("-", [
		local.default_tags.Project, local.default_tags.Region, local.default_tags.Application
	])
	
	region = "ap-northeast-2"
	
	cluster_version = "1.29"
	
	vpc_id   = "vpc-0da64abc5052e21e2"
	vpc_cidr = "10.0.0.0/16"
	azs      = ["ap-northeast-2a", "ap-northeast-2c"]
	az_count = length(local.azs)
	
	enable_ingress          = true
	is_route53_private_zone = false
	
	domain_name      = "nokoga.com"
	argocd_subdomain = "gitops"
	argocd_host      = "${local.argocd_subdomain}.${local.domain_name}"
	route53_zone_arn = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.this[0].zone_id}"
	
	gitops_addons_url      = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
	gitops_addons_basepath = var.gitops_addons_basepath
	gitops_addons_path     = var.gitops_addons_path
	gitops_addons_revision = var.gitops_addons_revision
	
	aws_addons = {
		enable_cert_manager                          = try(var.addons.enable_cert_manager, false)
		enable_aws_efs_csi_driver                    = try(var.addons.enable_aws_efs_csi_driver, false)
		enable_aws_fsx_csi_driver                    = try(var.addons.enable_aws_fsx_csi_driver, false)
		enable_aws_cloudwatch_metrics                = try(var.addons.enable_aws_cloudwatch_metrics, false)
		enable_aws_privateca_issuer                  = try(var.addons.enable_aws_privateca_issuer, false)
		enable_cluster_autoscaler                    = try(var.addons.enable_cluster_autoscaler, false)
		enable_external_dns                          = try(var.addons.enable_external_dns, false)
		enable_external_secrets                      = try(var.addons.enable_external_secrets, false)
		enable_aws_load_balancer_controller          = try(var.addons.enable_aws_load_balancer_controller, false)
		enable_fargate_fluentbit                     = try(var.addons.enable_fargate_fluentbit, false)
		enable_aws_for_fluentbit                     = try(var.addons.enable_aws_for_fluentbit, false)
		enable_aws_node_termination_handler          = try(var.addons.enable_aws_node_termination_handler, false)
		enable_karpenter                             = try(var.addons.enable_karpenter, false)
		enable_velero                                = try(var.addons.enable_velero, false)
		enable_aws_gateway_api_controller            = try(var.addons.enable_aws_gateway_api_controller, false)
		enable_aws_ebs_csi_resources                 = try(var.addons.enable_aws_ebs_csi_resources, false)
		enable_aws_secrets_store_csi_driver_provider = try(var.addons.enable_aws_secrets_store_csi_driver_provider, false)
		enable_ack_apigatewayv2                      = try(var.addons.enable_ack_apigatewayv2, false)
		enable_ack_dynamodb                          = try(var.addons.enable_ack_dynamodb, false)
		enable_ack_s3                                = try(var.addons.enable_ack_s3, false)
		enable_ack_rds                               = try(var.addons.enable_ack_rds, false)
		enable_ack_prometheusservice                 = try(var.addons.enable_ack_prometheusservice, false)
		enable_ack_emrcontainers                     = try(var.addons.enable_ack_emrcontainers, false)
		enable_ack_sfn                               = try(var.addons.enable_ack_sfn, false)
		enable_ack_eventbridge                       = try(var.addons.enable_ack_eventbridge, false)
		enable_aws_argocd_ingress                    = try(var.addons.enable_aws_argocd_ingress, false)
	}
	oss_addons = {
		enable_argocd                          = try(var.addons.enable_argocd, false)
		enable_argo_rollouts                   = try(var.addons.enable_argo_rollouts, false)
		enable_argo_events                     = try(var.addons.enable_argo_events, false)
		enable_argo_workflows                  = try(var.addons.enable_argo_workflows, false)
		enable_cluster_proportional_autoscaler = try(var.addons.enable_cluster_proportional_autoscaler, false)
		enable_gatekeeper                      = try(var.addons.enable_gatekeeper, false)
		enable_gpu_operator                    = try(var.addons.enable_gpu_operator, false)
		enable_ingress_nginx                   = try(var.addons.enable_ingress_nginx, false)
		enable_kyverno                         = try(var.addons.enable_kyverno, false)
		enable_kube_prometheus_stack           = try(var.addons.enable_kube_prometheus_stack, false)
		enable_metrics_server                  = try(var.addons.enable_metrics_server, false)
		enable_prometheus_adapter              = try(var.addons.enable_prometheus_adapter, false)
		enable_secrets_store_csi_driver        = try(var.addons.enable_secrets_store_csi_driver, false)
		enable_vpa                             = try(var.addons.enable_vpa, false)
	}
	addons = merge(
		local.aws_addons,
		local.oss_addons,
		{ kubernetes_version = local.cluster_version },
		{ aws_cluster_name = module.eks.cluster_name }
	)
	
	addons_metadata = merge(
		module.eks_blueprints_addons.gitops_metadata,
		{
			aws_cluster_name = module.eks.cluster_name
			aws_region       = local.region
			aws_account_id   = data.aws_caller_identity.current.account_id
			aws_vpc_id       = local.vpc_id
		},
		{
			argocd_hosts                = "[${local.argocd_host}]"
			external_dns_domain_filters = "[${local.domain_name}]"
		},
		{
			addons_repo_url      = local.gitops_addons_url
			addons_repo_basepath = local.gitops_addons_basepath
			addons_repo_path     = local.gitops_addons_path
			addons_repo_revision = local.gitops_addons_revision
		}
	)
	
	argocd_apps = {
		addons    = file("${path.module}/bootstrap/addons.yaml")
	}
	
	tags = merge({
		Blueprint  = local.name
		GithubRepo = "github.com/gitops-bridge-dev/gitops-bridge"
	}, local.default_tags)
	
	default_tags = {
		Managed     = "terraform"
		Region      = "ane2"
		Project     = "study"
		Environment = "prod"
		Application = "hub"
	}
	
}