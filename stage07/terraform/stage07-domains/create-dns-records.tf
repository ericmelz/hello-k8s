data "aws_lb" "load_balancer" {
  arn = var.load_balancer_arn
}

resource "aws_route53_record" "alias_records" {
  for_each = toset(var.domains)
  zone_id  = aws_route53_zone.zones[each.key].zone_id
  name     = each.key
  type     = "A"

  alias {
    name                   = data.aws_lb.load_balancer.dns_name
    zone_id                = data.aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}
