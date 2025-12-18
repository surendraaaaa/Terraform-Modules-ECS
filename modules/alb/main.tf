# Frontend ALB
resource "aws_lb" "frontend" {
  name               = "${var.name_prefix}-alb-frontend"
  internal           = var.enable_public_frontend ? false : true
  load_balancer_type = "application"
  security_groups    = [var.alb_frontend_sg_id]
  subnets            = var.enable_public_frontend ? var.public_subnet_ids : var.private_subnet_ids
  tags               =  { 
    Name = "${var.name_prefix}-alb-frontend"
    }
}

resource "aws_lb_target_group" "frontend_tg" {
  name        = "${var.name_prefix}-tg-frontend"
  port        = var.frontend_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.frontend_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags =  {
    Name = "${var.name_prefix}-tg-frontend"
     }
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"
  default_action { 
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    }
}

# Backend ALB (internal)
resource "aws_lb" "backend" {
  name               = "${var.name_prefix}-alb-backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_backend_sg_id]
  subnets            = var.private_subnet_ids
  tags               =  { 
    Name = "${var.name_prefix}-alb-backend"
     }
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "${var.name_prefix}-tg-backend"
  port        = var.backend_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.backend_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { 
    Name = "${var.name_prefix}-tg-backend"
     }
}

resource "aws_lb_listener" "backend_http" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 80
  protocol          = "HTTP"
  default_action { 
    type = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
    }
}
