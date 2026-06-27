output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}
output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}
output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = [for subnet in aws_subnet.public : subnet.id]
}
output "private_ecs_subnet_ids" {
  description = "Private ECS subnet IDs."
  value       = [for subnet in aws_subnet.private_ecs : subnet.id]
}
output "database_subnet_ids" {
  description = "Database subnet IDs."
  value       = [for subnet in aws_subnet.database : subnet.id]
}

