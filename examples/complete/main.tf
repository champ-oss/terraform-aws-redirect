terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  git = "terraform-aws-redirect"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "this" {
  tags = {
    purpose = "vega"
    Type    = "Public"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.117-6aa9478"
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
  public_subnet_ids = data.aws_subnets.this.ids
  vpc_id            = data.aws_vpcs.this.ids[0]
}

output "hostname" {
  description = "DNS hostname"
  value       = "${local.git}.${data.aws_route53_zone.this.name}"
}
