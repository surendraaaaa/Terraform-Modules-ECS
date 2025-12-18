variable "name_prefix" { 
type = string
 }
variable "vpc_id" { 
    type = string
     }
variable "private_subnet_cidrs" { 
    type = list(string)
     }
variable "frontend_container_port" { 
    type = number
     }
variable "backend_container_port" { 
    type = number
     }
variable "enable_public_frontend" { 
    type = bool
     }
variable "allow_ssh_cidr" { 
    type = string
     }
variable "key_pair_name" { 
    type = string
     }

