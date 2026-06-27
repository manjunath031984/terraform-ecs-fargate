variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "vpc_id" {
  description = "VPC ID."
  type        = string
}
variable "flow_log_subnet_ids" {
  description = "Subnet IDs included in flow logging context."
  type        = list(string)
}
variable "cloudwatch_kms_key_arn" {
  description = "CloudWatch KMS key ARN."
  type        = string
}
variable "log_retention_days" {
  description = "Log retention days."
  type        = number
}
variable "alb_access_log_prefix" {
  description = "ALB access log prefix."
  type        = string
}
variable "nlb_access_log_prefix" {
  description = "NLB access log prefix."
  type        = string
}
variable "cloudtrail_s3_key_prefix" {
  description = "CloudTrail S3 prefix."
  type        = string
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

