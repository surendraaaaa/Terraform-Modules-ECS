locals {
  env         = terraform.workspace
  name_prefix = "${var.project_name}-${local.env}"

  tags = {
    Project     = var.project_name
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}
