//set to remote backend which was terraformed with terraform/init folder
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-state-gitranker"
    region = "eu-west-3"
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region  = "eu-west-3"
}

module "api" {
  source = "./modules/api"

  providers = {
    aws = aws
  }

  app_name = "gitranker"
  aws_region = "eu-west-3"
  cidr_block = "10.10.10.0/24"
}

module "frontend" {
  source = "./modules/frontend"

  providers = {
    aws = aws
  }

  frontend_subdomain = "gitranker"
}