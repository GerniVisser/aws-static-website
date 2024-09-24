# ACM certificate resource with the domain name and DNS validation method, supporting subject alternative names
# resource "aws_acm_certificate" "cert" {
#   provider          = aws.us-east-1
#   domain_name       = var.domain_name
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "site_cert_validation" {
#   provider                = aws.us-east-1
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [aws_route53_record.site_cert_dns.fqdn]
# }