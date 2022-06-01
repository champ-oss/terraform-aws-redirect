resource "aws_route53_record" "this" {
  for_each = toset(var.route53_records)
  name     = each.value
  type     = "A"
  zone_id  = var.zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}