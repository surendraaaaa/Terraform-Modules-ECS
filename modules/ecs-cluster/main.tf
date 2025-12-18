resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-cluster"
  setting { 
    name = "containerInsights"
    value = "enabled"
     }
  tags = { 
    Name = "${var.name_prefix}-cluster"
    }
}

# ECS-optimized AMI
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.name_prefix}-lt-ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.ecs_instance_type
  key_name      = var.key_pair_name != "" ? var.key_pair_name : null

  iam_instance_profile { 
    name = var.ecs_instance_profile_name
}

  network_interfaces {
    security_groups             = [var.ecs_instance_sg_id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.this.name}" >> /etc/ecs/ecs.config
    systemctl enable --now ecs
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = { 
        Name = "${var.name_prefix}-ecs-node" 
        }
  }

  tags = { 
    Name = "${var.name_prefix}-lt-ecs"
    }
}

resource "aws_autoscaling_group" "ecs" {
  name                = "${var.name_prefix}-asg-ecs"
  desired_capacity    = var.ecs_desired_capacity
  min_size            = var.ecs_min_size
  max_size            = var.ecs_max_size
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-ecs-node"
    propagate_at_launch = true
  }

  lifecycle { 
    create_before_destroy = true
    }
}

resource "aws_ecs_capacity_provider" "asg" {
  name = "${var.name_prefix}-cp-asg"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
    }
    managed_termination_protection = "ENABLED"
  }

  tags =  { 
    Name = "${var.name_prefix}-cp-asg"
     }
}

resource "aws_ecs_cluster_capacity_providers" "attach" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.asg.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg.name
    weight            = 1
    base              = 0
  }
}
