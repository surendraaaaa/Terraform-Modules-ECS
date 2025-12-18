output "frontend_tg_arn" { 
    value = aws_lb_target_group.frontend_tg.arn
     }
output "backend_tg_arn" { 
    value = aws_lb_target_group.backend_tg.arn
     }
output "frontend_alb_dns" { 
    value = aws_lb.frontend.dns_name
     }
output "backend_alb_dns" { 
    value = aws_lb.backend.dns_name
     }
