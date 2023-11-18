resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  # In a real production scenario we would likely configure these access logs for some or all of our load balancers.
  # Leaving it out of scope for this exercise for the sake of brevity.
  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name        = "${var.name}-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "this" {
  #ts:skip=AWS.ALTG.IS.MEDIUM.0042 Upgrading our backends to support e2e HTTPS is considered out of scope currently.

  name     = "${var.name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name        = "${var.name}-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_route53_record" "lb_dns" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.this.dns_name]
}

resource "aws_lb_listener" "http_redirect" {
  #ts:skip=AWS.ALL.IS.MEDIUM.0046 We *do* have an HTTPS listener.

  count = var.redirect_http ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
