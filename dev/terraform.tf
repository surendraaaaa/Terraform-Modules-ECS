# terraform init
# terraform plan -var-file=dev.tfvars
# terraform apply -var-file=dev.tfvars

# terraform plan -var-file=staging.tfvars
# terraform apply -var-file=staging.tfvars

# terraform plan -var-file=prod.tfvars
# terraform apply -var-file=prod.tfvars



terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # cloud {
  #    organization = "my-remote-backend"
  #     workspaces {
  #      name = "dev"
  #    }
  #  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = terraform.workspace
      ManagedBy   = "Terraform"
    }
  }
}
