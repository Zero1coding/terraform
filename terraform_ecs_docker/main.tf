#################################
# ECS CLUSTER
#################################

resource "aws_ecs_cluster" "app_cluster" {
  name = "flask-node-ecs-cluster"
}

#################################
# SECURITY GROUP
#################################

resource "aws_security_group" "ecs_sg" {
  name   = "ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#################################
# BACKEND TASK DEFINITION
#################################

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "flask-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "flask-backend"
      image     = "${var.backend_ecr_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 5000
      }]
    }
  ])
}

#################################
# FRONTEND TASK DEFINITION
#################################

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "node-frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "node-frontend"
      image     = "${var.frontend_ecr_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 3000
      }]
    }
  ])
}

#################################
# BACKEND SERVICE
#################################

resource "aws_ecs_service" "backend_service" {
  name            = "flask-backend-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "flask-backend"
    container_port   = 5000
  }

}

#################################
# FRONTEND SERVICE
#################################

resource "aws_ecs_service" "frontend_service" {
  name            = "node-frontend-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "node-frontend"
    container_port   = 3000
  }


}
#################################
# APPLICATION LOAD BALANCER
#################################

resource "aws_lb" "app_alb" {
  name               = "flask-node-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.ecs_sg.id]
}
#################################
# TARGET GROUPS
#################################

resource "aws_lb_target_group" "frontend_tg" {
  name        = "frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "backend-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }
}
#################################
# ALB LISTENER
#################################

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}
#################################
# BACKEND ROUTING RULE
#################################

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/items*", "/count*", "/submit*", "/find*"]
    }
  }
}

