output "frontend_alb_dns" {
  description = "DNS name of the frontend ALB"
  value       = module.alb.frontend_alb_dns
}

output "backend_alb_dns" {
  description = "DNS name of the backend ALB"
  value       = module.alb.backend_alb_dns
}

output "frontend_tg_arn" {
  description = "Target group ARN for frontend service"
  value       = module.alb.frontend_tg_arn
}

output "backend_tg_arn" {
  description = "Target group ARN for backend service"
  value       = module.alb.backend_tg_arn
}
