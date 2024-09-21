resource "aws_route53_domain" "domains" {
  for_each   = toset(var.domains)
  domain_name = each.key

  admin_contact {
    first_name   = "Eric"
    last_name    = "Melz"
    contact_type = "PERSON"
    email        = "eric@emelz.com"
    phone_number = "+1.3106145376"
    address_line_1 = "300 S Reeves Dr"
    city           = "Beverly Hills"
    state          = "CA"
    country_code   = "US"
    zip_code       = "90212"
  }

  registrant_contact = admin_contact
  tech_contact       = admin_contact

  privacy_protection = true
  auto_renew         = true
}
