# VPC
module "vpc" {
  source               = "../modules/vpc"
  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

}

# Security groups
module "security" {
  source                  = "../modules/security-group"
  name_prefix             = local.name_prefix
  vpc_id                  = module.vpc.vpc_id
  private_subnet_cidrs    = module.vpc.private_subnet_cidrs
  frontend_container_port = var.frontend_container_port
  backend_container_port  = var.backend_container_port
  enable_public_frontend  = var.enable_public_frontend
  allow_ssh_cidr          = var.allow_ssh_cidr
  key_pair_name           = var.key_pair_name

}

# IAM for ECS (restrict secrets to RDS arns via inputs)
module "iam" {
  source      = "../modules/iam"
  name_prefix = local.name_prefix
  region      = var.region
  tags        = local.tags
  allowed_secret_arns = [
    module.rds.db_user_secret_arn,
    module.rds.db_password_secret_arn
  ]
}

# CloudWatch logs
module "logs" {
  source         = "../modules/cloud-watch"
  name_prefix    = local.name_prefix
  retention_days = var.log_retention_days
  tags           = local.tags
}

# ECS cluster with ASG capacity provider
module "ecs_cluster" {
  depends_on                = [module.vpc]
  source                    = "../modules/ecs-cluster"
  name_prefix               = local.name_prefix
  private_subnet_ids        = module.vpc.private_subnet_ids
  ecs_instance_type         = var.ecs_instance_type
  ecs_desired_capacity      = var.ecs_desired_capacity
  ecs_min_size              = var.ecs_min_size
  ecs_max_size              = var.ecs_max_size
  key_pair_name             = var.key_pair_name
  ecs_instance_sg_id        = module.security.ecs_instances_sg_id
  ecs_instance_profile_name = module.iam.ecs_instance_profile_name
  tags                      = local.tags
}

# RDS + Secrets
module "rds" {
  source                 = "../modules/rds"
  name_prefix            = local.name_prefix
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  rds_sg_id              = module.security.rds_sg_id
  db_name                = var.db_name
  db_engine_version      = var.db_engine_version
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_multi_az            = var.db_multi_az
  db_deletion_protection = var.db_deletion_protection
  db_backup_retention    = var.db_backup_retention
  tags                   = local.tags
}




# ALBs (frontend public, backend internal)
module "alb" {
  source                     = "../modules/alb"
  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  private_subnet_ids         = module.vpc.private_subnet_ids
  enable_public_frontend     = var.enable_public_frontend
  alb_frontend_sg_id         = module.security.alb_frontend_sg_id
  alb_backend_sg_id          = module.security.alb_backend_sg_id
  frontend_container_port    = var.frontend_container_port
  backend_container_port     = var.backend_container_port
  frontend_health_check_path = var.frontend_health_check_path
  backend_health_check_path  = var.backend_health_check_path
  tags                       = local.tags
}


# Frontend ECS Service

module "frontend_service" {
  source                      = "../modules/ecs-service"
  name_prefix                 = local.name_prefix
  service_name                = "frontend"
  cluster_id                  = module.ecs_cluster.cluster_id
  capacity_provider           = module.ecs_cluster.capacity_provider_name
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  image                       = var.frontend_image
  container_port              = var.frontend_container_port
  desired_count               = 0 # 2 make it zero for destruction
  subnets                     = module.vpc.private_subnet_ids
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn

  # Use the ECS tasks SG (ALB hits this SG)
  ecs_tasks_sg_id = module.security.ecs_tasks_sg_id
  service_sg_id   = module.security.ecs_tasks_sg_id

  target_group_arn = module.alb.frontend_tg_arn
  log_group_name   = module.logs.frontend_log_group_name
  env_vars         = [{ name = "NODE_ENV", value = local.env }]
  region           = var.region
  tags             = local.tags
  depends_on       = [module.alb]
}


# Backend ECS Service

module "backend_service" {
  source                      = "../modules/ecs-service"
  name_prefix                 = local.name_prefix
  service_name                = "backend"
  cluster_id                  = module.ecs_cluster.cluster_id
  capacity_provider           = module.ecs_cluster.capacity_provider_name
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  image                       = var.backend_image
  container_port              = var.backend_container_port
  desired_count               = 0 # 2 make it zero for destruction
  subnets                     = module.vpc.private_subnet_ids
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn

  # Use the ECS tasks SG (ALB hits this SG)
  ecs_tasks_sg_id = module.security.ecs_tasks_sg_id
  service_sg_id   = module.security.ecs_tasks_sg_id

  target_group_arn = module.alb.backend_tg_arn
  log_group_name   = module.logs.backend_log_group_name

  env_vars = [
    { name = "DB_HOST", value = module.rds.db_endpoint },
    { name = "DB_NAME", value = var.db_name }
  ]

  secret_env_vars = [
    { name = "DB_USER", value_from = module.rds.db_user_secret_arn },
    { name = "DB_PASSWORD", value_from = module.rds.db_password_secret_arn }
  ]

  healthcheck_cmd = "curl -fsS http://127.0.0.1:${var.backend_container_port}${var.backend_health_check_path} || exit 1"


  region     = var.region
  tags       = local.tags
  depends_on = [module.alb, module.rds]
}



