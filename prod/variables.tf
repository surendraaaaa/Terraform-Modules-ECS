variable "project_name" {
  type        = string
  description = "Project name used in naming and tags."
}

variable "region" {
  type        = string
  description = "AWS region."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for public subnets."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for private subnets."
}

variable "enable_public_frontend" {
  type        = bool
  description = "Expose frontend ALB to the internet."
}

variable "frontend_container_port" {
  type        = number
  description = "Frontend container port."
}

variable "backend_container_port" {
  type        = number
  description = "Backend container port."
}

variable "frontend_image" {
  type        = string
  description = "Frontend container image."
}

variable "backend_image" {
  type        = string
  description = "Backend container image."
}

variable "frontend_health_check_path" {
  type        = string
  description = "Frontend health check path."
}

variable "backend_health_check_path" {
  type        = string
  description = "Backend health check path."
}

variable "ecs_instance_type" {
  type        = string
  description = "EC2 instance type for ECS."
}

variable "ecs_desired_capacity" {
  type        = number
  description = "Desired ASG capacity."
}

variable "ecs_min_size" {
  type        = number
  description = "Min ASG size."
}

variable "ecs_max_size" {
  type        = number
  description = "Max ASG size."
}

variable "key_pair_name" {
  type        = string
  description = "EC2 key pair name for SSH (optional)."
}

variable "allow_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH (optional)."
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class."
}

variable "db_allocated_storage" {
  type        = number
  description = "RDS storage in GB."
}

variable "db_engine_version" {
  type        = string
  description = "MySQL engine version."
}

variable "db_name" {
  type        = string
  description = "Database name."
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ."
}

variable "db_deletion_protection" {
  type        = bool
  description = "RDS deletion protection."
}

variable "db_backup_retention" {
  type        = number
  description = "Backup retention days."
}

variable "container_cpu" {
  type        = number
  description = "CPU units for tasks."
}

variable "container_memory" {
  type        = number
  description = "Memory MiB for tasks."
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention."
}



# variable "project_name" {
#   type        = string
#   description = "Project name used in naming and tags."
#   default     = "notes-app"
# }

# variable "region" {
#   type        = string
#   description = "AWS region."
#   default     = "us-east-2"
# }

# variable "vpc_cidr" {
#   type        = string
#   description = "CIDR for the VPC."
#   default     = "10.0.0.0/16"
# }

# variable "public_subnet_cidrs" {
#   type        = list(string)
#   description = "CIDRs for public subnets."
#   default     = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "private_subnet_cidrs" {
#   type        = list(string)
#   description = "CIDRs for private subnets."
#   default     = ["10.0.3.0/24", "10.0.4.0/24"]
# }

# variable "enable_public_frontend" {
#   type        = bool
#   description = "Expose frontend ALB to the internet."
#   default     = true
# }

# variable "frontend_container_port" {
#   type        = number
#   description = "Frontend container port."
#   default     = 80
# }

# variable "backend_container_port" {
#   type        = number
#   description = "Backend container port."
#   default     = 5000
# }

# variable "frontend_image" {
#   type        = string
#   description = "Frontend container image."
#   default     = "public.ecr.aws/docker/library/nginx:stable"
# }

# variable "backend_image" {
#   type        = string
#   description = "Backend container image."
#   default     = "public.ecr.aws/docker/library/httpd:2.4"
# }

# variable "backend_health_check_path" {
#   type        = string
#   description = "Backend health check path."
#   default     = "/health"
# }

# variable "frontend_health_check_path" {
#   type        = string
#   description = "Frontend health check path."
#   default     = "/"
# }

# variable "ecs_instance_type" {
#   type        = string
#   description = "EC2 instance type for ECS."
#   default     = "t3.small"
# }

# variable "ecs_desired_capacity" {
#   type        = number
#   description = "Desired ASG capacity."
#   default     = 2
# }

# variable "ecs_min_size" {
#   type        = number
#   description = "Min ASG size."
#   default     = 1
# }

# variable "ecs_max_size" {
#   type        = number
#   description = "Max ASG size."
#   default     = 4
# }

# variable "key_pair_name" {
#   type        = string
#   description = "EC2 key pair name for SSH (optional)."
#   default     = "MyAWSKP"
# }

# variable "allow_ssh_cidr" {
#   type        = string
#   description = "CIDR allowed to SSH (optional)."
#   default     = "0.0.0.0/0"
# }

# variable "db_instance_class" {
#   type        = string
#   description = "RDS instance class."
#   default     = "db.t3.micro"
# }

# variable "db_allocated_storage" {
#   type        = number
#   description = "RDS storage in GB."
#   default     = 20
# }

# variable "db_engine_version" {
#   type        = string
#   description = "MySQL engine version."
#   default     = "8.0.35"
# }

# variable "db_name" {
#   type        = string
#   description = "Database name."
#   default     = "notes_db"
# }

# variable "db_multi_az" {
#   type        = bool
#   description = "Enable Multi-AZ."
#   default     = false
# }

# variable "db_deletion_protection" {
#   type        = bool
#   description = "RDS deletion protection."
#   default     = false
# }

# variable "db_backup_retention" {
#   type        = number
#   description = "Backup retention days."
#   default     = 7
# }

# variable "container_cpu" {
#   type        = number
#   description = "CPU units for tasks."
#   default     = 256
# }

# variable "container_memory" {
#   type        = number
#   description = "Memory MiB for tasks."
#   default     = 512
# }

# variable "log_retention_days" {
#   type        = number
#   description = "CloudWatch log retention."
#   default     = 14
# }
