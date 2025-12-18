variable "name_prefix" { 
    type = string
     }
variable "private_subnet_ids" { 
    type = list(string)
     }
variable "ecs_instance_type" { 
    type = string
     }
variable "ecs_desired_capacity" { 
    type = number
     }
variable "ecs_min_size" { 
    type = number
     }
variable "ecs_max_size" { 
    type = number
     }
variable "key_pair_name" {
    type = string
     }
variable "ecs_instance_sg_id" { 
    type = string
     }
variable "ecs_instance_profile_name" { 
    type = string
     }
variable "tags" { 
    type = map(string)
     }
