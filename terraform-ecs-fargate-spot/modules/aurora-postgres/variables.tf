variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "database_name" {
  description = "Database name."
  type        = string
}
variable "master_username" {
  description = "Master username."
  type        = string
}
variable "master_password_secret_arn" {
  description = "Secret ARN containing database password JSON."
  type        = string
}
variable "engine_version" {
  description = "Aurora PostgreSQL engine version."
  type        = string
}
variable "instance_class" {
  description = "Aurora instance class."
  type        = string
}
variable "subnet_ids" {
  description = "Database subnet IDs."
  type        = list(string)
}
variable "security_group_ids" {
  description = "Security group IDs."
  type        = list(string)
}
variable "kms_key_arn" {
  description = "KMS key ARN."
  type        = string
}
variable "backup_retention_days" {
  description = "Backup retention days."
  type        = number
}
variable "deletion_protection" {
  description = "Deletion protection."
  type        = bool
}
variable "performance_insights_kms_arn" {
  description = "PI KMS ARN."
  type        = string
}
variable "cloudwatch_log_exports" {
  description = "CloudWatch log exports."
  type        = list(string)
  default     = ["postgresql"]
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

