resource "aws_route53_zone" "private" {
  count = var.create_zone ? 1 : 0
  name  = var.zone_name

  vpc { vpc_id = var.vpc_id }

  tags = merge(var.tags, { Name = var.zone_name })
}

locals { zone_id = var.create_zone ? aws_route53_zone.private[0].zone_id : var.existing_zone_id }

resource "aws_route53_record" "api" {
  count   = var.create_zone ? 0 : 1
  zone_id = local.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.nlb_dns_name
    zone_id                = var.nlb_zone_id
    evaluate_target_health = true
  }
}

