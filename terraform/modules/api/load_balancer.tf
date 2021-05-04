resource "aws_lb" "ecs" {
  name               = "alb"
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.public-alb-a.id,
    aws_subnet.public-alb-b.id
  ]
  security_groups   = [
    aws_security_group.ingress_http.id,
    aws_security_group.ingress_https.id,
    aws_security_group.ingress_api.id,
    aws_security_group.egress_all.id,
  ]

  tags = merge(local.default_tags,
    {
      Name = "alb-ecs"
    }
  )
}

resource "aws_lb_listener" "alb-http-https-redirect" {
  load_balancer_arn = aws_lb.ecs.id
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type          = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      # query       = "#{query}"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_lb.ecs]
}

resource "aws_alb_listener" "alb-https-listener" {
  load_balancer_arn  = aws_lb.ecs.arn
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = aws_acm_certificate.api.arn

  default_action {
    target_group_arn = aws_lb_target_group.alb_ecs_backend.arn
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.alb_ecs_backend, aws_lb.ecs]
}

resource "aws_lb_listener_certificate" "alb-https-listener" {
  listener_arn    = aws_alb_listener.alb-https-listener.arn
  certificate_arn = aws_acm_certificate.api.arn
}

resource "aws_lb_target_group" "alb_ecs_backend" {
  name        = "alb-ecs-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.default.id

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = merge(local.default_tags,
    {
      Name = "alb-api-target-group"
    }
  )

  depends_on = [aws_lb.ecs]
}
