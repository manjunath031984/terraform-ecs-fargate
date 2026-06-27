output "nlb_security_group_id" {
  description = "NLB security group ID."
  value       = aws_security_group.nlb.id
}
output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = aws_security_group.alb.id
}
output "ecs_tasks_security_group_id" {
  description = "ECS tasks security group ID."
  value       = aws_security_group.ecs_tasks.id
}
output "aurora_security_group_id" {
  description = "Aurora security group ID."
  value       = aws_security_group.aurora.id
}

