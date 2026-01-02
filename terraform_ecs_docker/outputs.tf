output "backend_ecr_url" {
  value = var.backend_ecr_url
}

output "frontend_ecr_url" {
  value = var.frontend_ecr_url
}
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
