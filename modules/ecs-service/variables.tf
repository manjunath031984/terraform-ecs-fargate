variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "cluster_id" {
  description = "ECS cluster ID."
  type        = string
}
variable "cluster_name" {
  description = "ECS cluster name."
  type        = string
}
variable "subnet_ids" {
  description = "Service subnet IDs."
  type        = list(string)
}
variable "security_group_ids" {
  description = "Security group IDs."
  type        = list(string)
}
variable "task_execution_role_arn" {
  description = "Task execution role ARN."
  type        = string
}
variable "task_role_arn" {
  description = "Task role ARN."
  type        = string
}
variable "container_name" {
  description = "Container name."
  type        = string
}
variable "container_image" {
  description = "Container image."
  type        = string
}
variable "container_port" {
  description = "Container port."
  type        = number
}
variable "cpu" {
  description = "Task CPU."
  type        = number
}
variable "memory" {
  description = "Task memory."
  type        = number
}
variable "desired_count" {
  description = "Desired tasks."
  type        = number
}
variable "health_check_grace_period_seconds" {
  description = "Health check grace period."
  type        = number
}
variable "target_group_arn" {
  description = "Target group ARN."
  type        = string
}
variable "log_group_name" {
  description = "Log group name."
  type        = string
}
variable "aws_region" {
  description = "AWS region."
  type        = string
}
variable "environment_variables" {
  description = "Environment variables."
  type        = map(string)
  default     = {}
}
variable "secrets" {
  description = "Secret env vars."
  type        = map(string)
  default     = {}
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

