output "service_name" { 
    value = aws_ecs_service.this.name
     }
output "task_family" { 
    value = aws_ecs_task_definition.this.family
     }
