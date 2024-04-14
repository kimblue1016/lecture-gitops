module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  count = length(var.repositories)
  repository_name  = var.repositories[count.index]

  repository_read_write_access_arns = ["arn:aws:iam::271251032508:role/Role-ECR"]

  repository_force_delete = true

  create_lifecycle_policy     = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection    = {
          tagStatus     = "untagged",
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.tags
}