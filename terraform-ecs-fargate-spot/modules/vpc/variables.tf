variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
}
variable "availability_zones" {
  description = "Availability zones."
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
}
variable "private_ecs_subnet_cidrs" {
  description = "Private ECS subnet CIDRs."
  type        = list(string)
}
variable "database_subnet_cidrs" {
  description = "Database subnet CIDRs."
  type        = list(string)
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

