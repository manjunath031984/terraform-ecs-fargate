variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "vpc_id" {
  description = "VPC ID."
  type        = string
}
variable "subnet_ids" {
  description = "ALB subnet IDs."
  type        = list(string)
}
variable "security_group_ids" {
  description = "ALB security group IDs."
  type        = list(string)
}
variable "certificate_arn" {
  description = "ACM certificate ARN."
  type        = string
}
variable "container_port" {
  description = "Container port."
  type        = number
}
variable "health_check_path" {
  description = "Health check path."
  type        = string
}
variable "enable_deletion_protection" {
  description = "Enable deletion protection."
  type        = bool
}
variable "enable_stickiness" {
  description = "Enable target stickiness."
  type        = bool
}
variable "access_logs_bucket" {
  description = "Access logs bucket."
  type        = string
}
variable "access_logs_prefix" {
  description = "Access logs prefix."
  type        = string
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

