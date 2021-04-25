
resource "aws_lb" "alb" {
  name               = "alb"
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.public-alb-a.id,
    aws_subnet.public-alb-b.id
  ]
  security_groups   = [
    aws_security_group.egress_all.id,
    aws_security_group.ingress_http.id,
    aws_security_group.ingress_api.id,
  ]

  tags = merge(local.default_tags,
    {
      Name      = "alb-${var.app_name}"
    }
  )
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api-backend.id
  }
}

resource "aws_lb_target_group" "api-backend" {
  name        = "alb-${var.app_name}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }
  depends_on = [aws_lb.alb]

  tags = merge(local.default_tags,
    {
      Name      = "alb-${var.app_name}"
    }
  )
}
