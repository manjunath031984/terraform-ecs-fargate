variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

