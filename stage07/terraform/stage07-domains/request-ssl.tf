resource "aws_acm_certificate" "certificates" {
  for_each         = toset(var.domains)
  domain_name      = each.key
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
