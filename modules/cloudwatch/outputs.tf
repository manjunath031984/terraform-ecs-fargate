output "ecs_log_group_name" {
  description = "ECS log group name."
  value       = try(aws_cloudwatch_log_group.ecs[0].name, null)
}
output "ecs_log_group_arn" {
  description = "ECS log group ARN."
  value       = try(aws_cloudwatch_log_group.ecs[0].arn, null)
}
output "alarm_topic_arn" {
  description = "SNS alarm topic ARN."
  value       = aws_sns_topic.alarms.arn
}
output "dashboard_name" {
  description = "CloudWatch dashboard name."
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}
output "dashboard_arn" {
  description = "CloudWatch dashboard ARN."
  value       = aws_cloudwatch_dashboard.this.dashboard_arn
}

