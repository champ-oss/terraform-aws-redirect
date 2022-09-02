provider "aws" {
  region = "us-west-1"
}

locals {
  git = "terraform-aws-redirect"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.32-86c316d"
  git                      = local.git
  availability_zones_count = 2
  retention_in_days        = 1
  create_private_subnets   = false
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.91-9badc61"
  git               = local.git
  domain_name       = "${local.git}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  source            = "../../"
  certificate_arn   = module.acm.arn
  git               = local.git
  route53_records   = ["${local.git}.${data.aws_route53_zone.this.name}"]
  host              = "github.com"
  path              = "/search"
  query             = "q=aws"
  zone_id           = data.aws_route53_zone.this.zone_id
  public_subnet_ids = module.vpc.public_subnets_ids
  vpc_id            = module.vpc.vpc_id
}