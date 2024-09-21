resource "aws_route53_record" "cert_validation_records" {
  for_each = {
    for domain in var.domains : domain => {
      zone_id = aws_route53_zone.zones[domain].zone_id
      records = [
        for dvo in aws_acm_certificate.certificates[domain].domain_validation_options : {
          name  = dvo.resource_record_name
          type  = dvo.resource_record_type
          value = dvo.resource_record_value
        }
      ]
    }
  }

  zone_id = each.value.zone_id
  name    = each.value.records[0].name
  type    = each.value.records[0].type
  records = [each.value.records[0].value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validations" {
  for_each = toset(var.domains)

  certificate_arn         = aws_acm_certificate.certificates[each.key].arn
  validation_record_fqdns = [aws_route53_record.cert_validation_records[each.key].fqdn]
}
