# ALB作成
resource "aws_lb" "alb" {
  name               = "${var.app_name}-${terraform.workspace}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id,
  ]
  internal                   = false
  enable_deletion_protection = false
}

# ターゲットグループ作成
resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.app_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 4
    matcher             = 200
  }
  depends_on = [aws_lb.alb]
}

# リスナー作成
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}