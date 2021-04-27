provider "aws" {
  alias   = "acm_certificates_provider"
  region  = "us-east-1" # To use an ACM Certificate with CloudFront, we must request the certificate from the US East (N. Virginia) region.
  version = "3.27"
}

data "aws_route53_zone" "root_domain" {
  name         = var.root_domain_name
  private_zone = false
}
