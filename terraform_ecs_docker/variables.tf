variable "backend_ecr_url" {
  description = "Backend ECR repository URL"
  type        = string
}

variable "frontend_ecr_url" {
  description = "Frontend ECR repository URL"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "Existing ECS Task Execution Role ARN"
  type        = string
}
