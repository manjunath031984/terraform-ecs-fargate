variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "subnet_ids" {
  description = "NLB subnet IDs."
  type        = list(string)
}
variable "security_group_ids" {
  description = "NLB security group IDs."
  type        = list(string)
}
variable "alb_arn" {
  description = "ALB ARN target."
  type        = string
}
variable "alb_listener_arn" {
  description = "ALB listener dependency ARN."
  type        = string
}
variable "alb_dns_name" {
  description = "ALB DNS name."
  type        = string
}
variable "vpc_id" {
  description = "VPC ID."
  type        = string
}
variable "enable_deletion_protection" {
  description = "Enable deletion protection."
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

