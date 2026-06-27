variable "repository_name" {
  description = "ECR repository name."
  type        = string
}
variable "kms_key_arn" {
  description = "KMS key ARN for ECR encryption."
  type        = string
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

