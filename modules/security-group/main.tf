# Frontend ALB SG
resource "aws_security_group" "alb_frontend" {
  name        = "${var.name_prefix}-sg-alb-frontend"
  description = "Frontend ALB SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.enable_public_frontend ? ["0.0.0.0/0"] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags =  { 
    Name = "${var.name_prefix}-sg-alb-frontend" 
    }
}

# Backend ALB SG (internal)
resource "aws_security_group" "alb_backend" {
  name        = "${var.name_prefix}-sg-alb-backend"
  description = "Backend ALB SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from private CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags =  { 
    Name = "${var.name_prefix}-sg-alb-backend"
    }

}

# ECS instances SG
resource "aws_security_group" "ecs_instances" {
  name        = "${var.name_prefix}-sg-ecs"
  description = "ECS instances SG"
  vpc_id      = var.vpc_id


  dynamic "ingress" {
    for_each = var.key_pair_name != "" ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allow_ssh_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags =  { 
    Name = "${var.name_prefix}-sg-ecs"
    }

}

# RDS SG
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-sg-rds"
  description = "RDS MySQL SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from ECS tasks"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-rds"
  }
}


# ECS TASKS SG (THIS IS WHAT ALB HITS)
resource "aws_security_group" "ecs_tasks" {
  name   = "${var.name_prefix}-sg-ecs-tasks"
  vpc_id = var.vpc_id

  ingress {
    description     = "Frontend ALB to frontend tasks"
    from_port       = var.frontend_container_port
    to_port         = var.frontend_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_frontend.id]
  }

  ingress {
    description     = "Backend ALB to backend tasks"
    from_port       = var.backend_container_port
    to_port         = var.backend_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



