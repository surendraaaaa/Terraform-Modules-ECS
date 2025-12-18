variable "name_prefix" { 
    type = string
     }
variable "vpc_id" { 
    type = string
     }
variable "public_subnet_ids" { 
    type = list(string)
     }
variable "private_subnet_ids" { 
    type = list(string)
     }
variable "enable_public_frontend" { 
    type = bool
     }
variable "alb_frontend_sg_id" { 
    type = string
     }
variable "alb_backend_sg_id" { 
    type = string
     }
variable "frontend_container_port" { 
    type = number
     }
variable "backend_container_port" { 
    type = number
     }
variable "frontend_health_check_path" { 
    type = string
     }
variable "backend_health_check_path" { 
    type = string
     }
variable "tags" { 
    type = map(string)
     }
