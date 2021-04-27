//set to remote backend which was terraformed with terraform/init folder
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-state-gitranker"
    region = "eu-west-3"
    key = "terraform.tfstate"
  }
}

data "aws_route53_zone" "selected" {
  name         = "cloudgate.link"
}

provider "aws" {
  region  = "eu-west-3"
}

provider "aws" {
  alias   = "acm_certificates_provider"
  region  = "us-east-1" # To use an ACM Certificate with CloudFront, we must request the certificate from the US East (N. Virginia) region.
}


module "frontend" {
  source = "./modules/frontend"

  providers = {
    aws = aws
  }

  web_bucket_name = "gitranker"
}

module "api" {
  source = "./modules/api"

  providers = {
    aws = aws
  }

  root_domain_name  = data.aws_route53_zone.selected.name
  api_subdomain     = "api"
  app_name          = "gitranker"
  aws_region        = "eu-west-3"
  cidr_block        = "10.10.10.0/24"
}


module "cdn" {
  source = "./modules/cdn"

  providers = {
    aws              = aws
    aws.acm_provider = aws.acm_certificates_provider
  }

  root_domain_name    = data.aws_route53_zone.selected.name
  frontend_subdomain  = "reporanker"
  web_bucket_id       = module.frontend.web_bucket_id
  website_endpoint    = module.frontend.web_bucket_website_endpoint
}
