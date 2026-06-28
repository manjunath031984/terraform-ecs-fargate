output "scalable_target_resource_id" {
  description = "Scalable target resource ID."
  value       = aws_appautoscaling_target.ecs.resource_id
}

