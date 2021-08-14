resource "aws_lb" "main" {
  name               = var.name
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.lb_SG
  subnets            = var.lb_subnet
  idle_timeout       = var.idle_timeout

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target-group" {
  count = length(var.target_groups)
  name        = lookup(var.target_groups[count.index], "name", null)
  port        = lookup(var.target_groups[count.index], "backend_port", null)
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.tg_vpc_id
  
  dynamic "health_check" {
    for_each = length(keys(lookup(var.target_groups[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "health_check", {})]

    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = var.listener_porotocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.*.id[0]
  }
}