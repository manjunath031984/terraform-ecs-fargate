variable "domain_name" {
  description = "Certificate domain name."
  type        = string
}
variable "private_hosted_zone_id" {
  description = "Private hosted zone ID for DNS validation."
  type        = string
}
variable "certificate_description" {
  description = "Certificate description."
  type        = string
  default     = "Internal TLS certificate"
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

