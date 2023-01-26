terraform {
  required_version = ">= 1.3.0"

  cloud {
    organization = "cklewar"

    workspaces {
      name = "f5-xc-aws-tgw-module"
    }
  }

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.18"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.33.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}
