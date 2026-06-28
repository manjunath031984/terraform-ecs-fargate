variable "zone_name" {
  description = "Private hosted zone name."
  type        = string
}
variable "record_name" {
  description = "API record name."
  type        = string
}
variable "vpc_id" {
  description = "VPC ID."
  type        = string
}
variable "nlb_dns_name" {
  description = "NLB DNS name."
  type        = string
}
variable "nlb_zone_id" {
  description = "NLB zone ID."
  type        = string
}
variable "certificate_name" {
  description = "Certificate name."
  type        = string
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
variable "create_zone" {
  description = "Create private zone."
  type        = bool
  default     = true
}
variable "existing_zone_id" {
  description = "Existing hosted zone ID when create_zone is false."
  type        = string
  default     = null
}


