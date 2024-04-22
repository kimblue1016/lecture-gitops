variable "addons" {
	description = "Kubernetes addons"
	type        = any
	default     = {
		enable_external_dns                 = true
		enable_aws_load_balancer_controller = true
		enable_aws_argocd_ingress           = true
		#enable_kube_prometheus_stack        = true
		#enable_metrics_server               = true
		#enable_prometheus_adapter           = true
		#enable_aws_cloudwatch_metrics       = true
		#enable_aws_for_fluentbit            = true
		#enable_karpenter                    = true
		#enable_velero                       = true
	}
}
# Addons Git
variable "gitops_addons_org" {
	description = "Git repository org/user contains for addons"
	type        = string
	default     = "https://github.com/gitops-bridge-dev"
}
variable "gitops_addons_repo" {
	description = "Git repository contains for addons"
	type        = string
	default     = "gitops-bridge-argocd-control-plane-template"
}
variable "gitops_addons_revision" {
	description = "Git repository revision/branch/ref for addons"
	type        = string
	default     = "main"
}
variable "gitops_addons_basepath" {
	description = "Git repository base path for addons"
	type        = string
	default     = ""
}
variable "gitops_addons_path" {
	description = "Git repository path for addons"
	type        = string
	default     = "bootstrap/control-plane/addons"
}