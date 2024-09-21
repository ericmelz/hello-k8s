output "nameservers" {
  value = {
    for domain in var.domains :
    domain => aws_route53_zone.zones[domain].name_servers
  }
}
