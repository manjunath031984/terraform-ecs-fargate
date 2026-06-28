variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "ecr_repository_arn" {
  description = "ECR repository ARN."
  type        = string
}
variable "log_group_arn" {
  description = "CloudWatch log group ARN."
  type        = string
}
variable "secrets_arns" {
  description = "Secrets Manager secret ARNs."
  type        = list(string)
}
variable "s3_bucket_arn" {
  description = "S3 bucket ARN."
  type        = string
}
variable "kms_key_arns" {
  description = "KMS key ARNs."
  type        = list(string)
}
variable "enable_execute_role" {
  description = "Enable ECS Exec permissions."
  type        = bool
  default     = true
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

