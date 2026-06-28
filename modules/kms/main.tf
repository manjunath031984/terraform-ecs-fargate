locals {
  keys = {
    s3         = "S3 application data and access log encryption"
    aurora     = "Aurora PostgreSQL encryption"
    secrets    = "Secrets Manager encryption"
    cloudwatch = "CloudWatch Logs encryption"
  }
}

resource "aws_kms_key" "this" {
  for_each                = local.keys
  description             = "${var.name_prefix} ${each.value}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  multi_region            = false
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-${each.key}-kms" })
}

resource "aws_kms_alias" "this" {
  for_each      = aws_kms_key.this
  name          = "alias/${var.name_prefix}-${each.key}"
  target_key_id = each.value.key_id
}

