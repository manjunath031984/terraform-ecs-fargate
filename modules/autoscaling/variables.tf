variable "name_prefix" {
  description = "Name prefix."
  type        = string
}
variable "cluster_name" {
  description = "ECS cluster name."
  type        = string
}
variable "service_name" {
  description = "ECS service name."
  type        = string
}
variable "min_capacity" {
  description = "Minimum task count."
  type        = number
}
variable "max_capacity" {
  description = "Maximum task count."
  type        = number
}
variable "cpu_scale_out" {
  description = "CPU scale out threshold."
  type        = number
}
variable "cpu_scale_in" {
  description = "CPU scale in threshold."
  type        = number
}
variable "memory_scale_out" {
  description = "Memory scale out threshold."
  type        = number
}
variable "memory_scale_in" {
  description = "Memory scale in threshold."
  type        = number
}
variable "alarm_actions" {
  description = "Alarm actions."
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

