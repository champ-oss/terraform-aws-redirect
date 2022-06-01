variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "certificate_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#certificate_arn"
  type        = string
}

variable "public_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id"
  type        = string
}

variable "host" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#host"
  type        = string
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "path" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#path"
  type        = string
  default     = null
}

variable "query" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#query"
  type        = string
  default     = null
}

variable "additional_certificate_arns" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate#certificate_arn"
  type        = list(string)
  default     = []
}

variable "route53_records" {
  description = "(Optional) List of A records to create, to be redirected"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#zone_id"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#ssl_policy"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

locals {
  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = "redirect"
  }
}
