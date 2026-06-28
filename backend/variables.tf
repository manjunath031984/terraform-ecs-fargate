variable "aws_account_id" {
  description = "AWS account ID allowed for backend bootstrap."
  type        = string
  default     = "980921723264"
}

variable "aws_region" {
  description = "AWS region for backend bootstrap resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tags."
  type        = string
  default     = "ecs-demo"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform remote state."
  type        = string
  default     = "ecs-demo-us-east-1"
}

variable "force_destroy_state_bucket" {
  description = "When true, delete all objects and object versions from the Terraform state bucket during destroy. Set to false only when intentionally preserving bucket contents."
  type        = bool
  default     = true
}
