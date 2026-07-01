variable "aws_account_id" {
  description = "AWS account ID allowed for deployment."
  type        = string
  default     = "980921723264"
}

variable "aws_region" {
  description = "AWS region for the S3 bucket."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, prod."
  }
}

variable "project_name" {
  description = "Project name used for tagging."
  type        = string
  default     = "trs"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name to create."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)) && !can(regex("\\.\\.", var.bucket_name)) && !can(regex("^-", var.bucket_name)) && !can(regex("-$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters, lowercase letters, numbers, dots, or hyphens, and start/end with a letter or number."
  }
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When true, delete all objects from the bucket during terraform destroy. Keep false for safer production defaults."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Additional tags applied to the S3 bucket."
  type        = map(string)
  default     = {}
}

