output "nlb_arn" {
  description = "NLB ARN."
  value       = aws_lb.this.arn
}
output "nlb_dns_name" {
  description = "NLB DNS name."
  value       = aws_lb.this.dns_name
}
output "nlb_zone_id" {
  description = "NLB hosted zone ID."
  value       = aws_lb.this.zone_id
}
output "nlb_arn_suffix" {
  description = "NLB ARN suffix."
  value       = aws_lb.this.arn_suffix
}

