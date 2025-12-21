variable "name_prefix" { 
    type = string
     }
variable "service_name" { 
    type = string
     }
variable "cluster_id" { 
    type = string
     }
variable "capacity_provider" { 
    type = string
     }
variable "container_cpu" { 
    type = number
     }
variable "container_memory" { 
    type = number
     }
variable "image" { 
    type = string
     }
variable "container_port" { 
    type = number
     }
variable "desired_count" { 
    type = number
     }
variable "subnets" { 
    type = list(string)
     }
variable "service_sg_id" { 
    type = string
     }
variable "target_group_arn" { 
    type = string
     }
variable "ecs_task_execution_role_arn" { 
    type = string
     }
variable "ecs_task_role_arn" { 
    type = string
     }
variable "log_group_name" { 
    type = string
     }
variable "env_vars" { 
    type = list(object({ 
        name = string,
        value = string 
        }))
     }
variable "secret_env_vars" {
  type = list(object({
    name       = string
    value_from = string
  }))
  default = []
}
variable "healthcheck_cmd" { 
    type = string
     default = "" 
     }
variable "region" { 
    type = string
     }
variable "tags" { 
    type = map(string)
     }
variable "ecs_tasks_sg_id" {
   type = string
}
