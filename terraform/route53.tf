# resource "aws_route53_zone" "main" {
#   name = var.domain_name
#   tags = {
#     Name        = "www.${var.domain_name}"
#     description = var.domain_name
#   }
#   comment = var.domain_name
# }

# # AWS Route53 record resource for certificate validation with dynamic for_each loop and properties for name, records, type, zone_id, and ttl.
# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   type            = each.value.type
#   zone_id         = aws_route53_zone.main.zone_id
#   ttl             = 60
# }

# resource "aws_route53_record" "base" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = var.domain_name
#   type    = "A"
#   alias {
#     name                   = aws_cloudfront_distribution.static_website_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.static_website_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "www.${var.domain_name}"
#   type    = "A"
#   alias {
#     name                   = aws_cloudfront_distribution.static_website_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.static_website_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# data "aws_route53_zone" "domain" {
#   name = var.domain_name
# }

# # ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
# resource "aws_route53_record" "site_cert_dns" {
#   allow_overwrite = true
#   name            = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
#   records         = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
#   type            = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.domain.zone_id
#   ttl             = 60
# }