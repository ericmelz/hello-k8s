resource "aws_route53_zone" "zones" {
  for_each = toset(var.domains)
  name     = each.key
}
