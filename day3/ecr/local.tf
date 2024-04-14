locals {
  region = "ap-northeast-2"

  tags = {
    Managed     = "terraform"
    Region      = "ane2"
    Project     = "lecture"
    Environment = "prd"
    Application = "hub"
  }

  name = join("-", [
    local.tags.Project, local.tags.Region, local.tags.Application, local.tags.Environment
  ])
}