output "alb_frontend_sg_id" { 
    value = aws_security_group.alb_frontend.id
     }
output "alb_backend_sg_id" { 
    value = aws_security_group.alb_backend.id
     }
output "ecs_instances_sg_id" { 
    value = aws_security_group.ecs_instances.id
     }
output "rds_sg_id" { 
    value = aws_security_group.rds.id
     }
