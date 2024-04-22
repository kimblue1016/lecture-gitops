terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
  }

  required_version = ">= 1.5.6"
}

provider "aws" {
  region = local.region
}