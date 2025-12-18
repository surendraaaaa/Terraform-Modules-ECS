variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type = string
  description = "The CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  type = list(string)
  description = "The CIDR blocks for the public subnets"
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
  type = list(string)
  description = "The CIDR blocks for the private subnets"
}   

variable "name_prefix" {
  default = "dev"
  type = string
  description = "The prefix for the names of the resources"
}

variable "azs" {
  type = list(string)
  default = ["us-east-2a", "us-east-2b"]
  description = "The availability zones to use for the VPC"
}


