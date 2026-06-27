variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "aurora_master_username" {
  description = "Aurora master username."
  type        = string
}
variable "aurora_database_name" {
  description = "Aurora database name."
  type        = string
}
variable "secrets_kms_key_id" {
  description = "Secrets KMS key ID."
  type        = string
}
variable "atlas_email_proxy_url" {
  description = "Atlas Email Proxy URL."
  type        = string
}
variable "adfs_metadata_url" {
  description = "ADFS metadata URL."
  type        = string
}
variable "smtp_username" {
  description = "SMTP username."
  type        = string
}
variable "recovery_window_in_days" {
  description = "Secret recovery window."
  type        = number
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

