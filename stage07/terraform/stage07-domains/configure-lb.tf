resource "aws_lb_listener" "https_listeners" {
  for_each          = toset(var.domains)
  load_balancer_arn = var.load_balancer_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.certificates[each.key].arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}
