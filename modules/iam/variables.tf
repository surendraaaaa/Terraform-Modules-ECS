variable "name_prefix" { 
    type = string
     }
variable "tags" { 
    type = map(string)
     }
variable "allowed_secret_arns" {
  type        = list(string)
  description = "List of Secrets Manager ARNs tasks may read."
  default     = []
}

variable "region" { 
    type = string
     }

