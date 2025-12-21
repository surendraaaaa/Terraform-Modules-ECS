locals {
  container_name = var.service_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name_prefix}-${var.service_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = var.image
      essential = true
      portMappings = [{
        containerPort = var.container_port
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = var.env_vars
      secrets     = [for s in var.secret_env_vars : { name = s.name, valueFrom = s.value_from }]
      healthCheck = var.healthcheck_cmd != "" ? {
        command  = ["CMD-SHELL", var.healthcheck_cmd]
        interval = 30
        timeout  = 5
        retries  = 3
      } : null
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.name_prefix}-svc-${var.service_name}"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  force_new_deployment               = true
  force_delete = true



  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.ecs_tasks_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 1
    base              = 1
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_minimum_healthy_percent = 0 # you can keep 50 in production 0 is for ECS to destory task immidiately and not wait
  deployment_maximum_percent         = 200

  tags = { 
    Name = "${var.name_prefix}-svc-${var.service_name}" 
    }
}
