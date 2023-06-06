# ECSのクラスター作成
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${terraform.workspace}"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.app_name}-task-definition"
  container_definitions    = file("${path.module}/tasks/container_definitions.json")
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.fargate_task_execution.arn
  execution_role_arn       = aws_iam_role.fargate_task_execution.arn
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "service_name" // 自分が作成したECSのサービス名に置き換える
  cluster                            = aws_ecs_cluster.ecs_cluster.arn
  task_definition                    = aws_ecs_task_definition.task.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "nginx-container"
    container_port   = "80"
  }

  network_configuration {
    subnets = [
      aws_subnet.private[0].id,
      aws_subnet.private[1].id,
    ]
    security_groups = [aws_security_group.main.id]
  }
}