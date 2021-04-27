# Creates the Route53 record to point on the ELB
data "aws_route53_zone" "main" {
  name         = var.root_domain_name
  private_zone = false
}

resource "aws_route53_record" "api_cdn_record" {
  name    = "${var.api_subdomain}.${var.root_domain_name}"
  zone_id = data.aws_route53_zone.main.zone_id
  type    = "A"


  alias {
    name                   = aws_lb.ecs.dns_name
    zone_id                = aws_lb.ecs.zone_id
    evaluate_target_health = true
  }
}
