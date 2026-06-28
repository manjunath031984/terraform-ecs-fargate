variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "log_retention_days" {
  description = "Log retention days."
  type        = number
}
variable "kms_key_arn" {
  description = "CloudWatch KMS key ARN."
  type        = string
}
variable "notification_email" {
  description = "Alarm notification email."
  type        = string
}
variable "create_log_group" {
  description = "Create ECS log group."
  type        = bool
  default     = true
}
variable "ecs_cluster_name" {
  description = "ECS cluster name for dashboard."
  type        = string
  default     = ""
}
variable "ecs_service_name" {
  description = "ECS service name for dashboard."
  type        = string
  default     = ""
}
variable "alb_arn_suffix" {
  description = "ALB ARN suffix."
  type        = string
  default     = ""
}
variable "alb_target_group_suffix" {
  description = "ALB target group ARN suffix."
  type        = string
  default     = ""
}
variable "nlb_arn_suffix" {
  description = "NLB ARN suffix."
  type        = string
  default     = ""
}
variable "aurora_cluster_id" {
  description = "Aurora cluster ID."
  type        = string
  default     = ""
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

