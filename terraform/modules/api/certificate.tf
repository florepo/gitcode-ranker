provider "aws" {
  alias   = "acm_certificates_provider"
  region  = "us-east-1" # To use an ACM Certificate with CloudFront, we must request the certificate from the US East (N. Virginia) region.
}

data "aws_route53_zone" "root_domain" {
  name         = var.root_domain_name
  private_zone = false
}

# ACM public Certificate, validate via DNS
resource "aws_acm_certificate" "api" {
  domain_name        = "${var.api_subdomain}.${var.root_domain_name}"
  validation_method  = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      Name = "api-alb-certificate"
    }
  )
}

resource "aws_acm_certificate_validation" "api_cert_validation" {
  provider                = aws
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert_validation : record.fqdn]
}

# Setup record for DNS validation of wildcard certificate
resource "aws_route53_record" "api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root_domain.zone_id
}