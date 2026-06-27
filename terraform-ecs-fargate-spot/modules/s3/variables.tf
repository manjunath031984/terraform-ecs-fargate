variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "bucket_name" {
  description = "Bucket name."
  type        = string
}
variable "kms_key_arn" {
  description = "KMS key ARN."
  type        = string
}
variable "lifecycle_transition_days" {
  description = "Transition days."
  type        = number
}
variable "lifecycle_expiration_days" {
  description = "Expiration days."
  type        = number
}
variable "access_log_bucket_name" {
  description = "Access log bucket name."
  type        = string
}
variable "access_log_bucket_policy_ready" {
  description = "Dependency on access log bucket policy."
  type        = string
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

