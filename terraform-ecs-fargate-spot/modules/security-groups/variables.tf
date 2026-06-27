variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "vpc_id" {
  description = "VPC ID."
  type        = string
}
variable "allowed_internal_cidrs" {
  description = "CIDRs allowed to reach NLB."
  type        = list(string)
}
variable "container_port" {
  description = "Application container port."
  type        = number
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

