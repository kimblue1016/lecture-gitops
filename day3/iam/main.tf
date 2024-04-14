module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

  tags = local.tags
}

module "iam_github_oidc_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"

  name = "Role-ECR"

  subjects = ["repo:torder32/*"]

  policies = {
    ECRPowerUser = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  }

  tags = local.tags
}