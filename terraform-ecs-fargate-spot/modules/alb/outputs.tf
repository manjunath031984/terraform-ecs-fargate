output "alb_arn" {
  description = "ALB ARN."
  value       = aws_lb.this.arn
}
output "alb_dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.this.dns_name
}
output "alb_zone_id" {
  description = "ALB hosted zone ID."
  value       = aws_lb.this.zone_id
}
output "alb_arn_suffix" {
  description = "ALB ARN suffix."
  value       = aws_lb.this.arn_suffix
}
output "https_listener_arn" {
  description = "HTTPS listener ARN."
  value       = aws_lb_listener.https.arn
}
output "ecs_target_group_arn" {
  description = "ECS target group ARN."
  value       = aws_lb_target_group.ecs.arn
}
output "ecs_target_group_arn_suffix" {
  description = "ECS target group ARN suffix."
  value       = aws_lb_target_group.ecs.arn_suffix
}

