output "zone_id" {
  description = "Private hosted zone ID."
  value       = local.zone_id
}
output "zone_name" {
  description = "Private hosted zone name."
  value       = var.zone_name
}
output "record_fqdn" {
  description = "API record FQDN."
  value       = try(aws_route53_record.api[0].fqdn, null)
}

