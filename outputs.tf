output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_ecs_subnet_ids" {
  description = "IDs of private ECS subnets."
  value       = module.vpc.private_ecs_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of database subnets."
  value       = module.vpc.database_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the internal Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the internal Application Load Balancer."
  value       = module.alb.alb_arn
}

output "nlb_dns_name" {
  description = "DNS name of the internet-facing Network Load Balancer."
  value       = module.nlb.nlb_dns_name
}

output "nlb_arn" {
  description = "ARN of the Network Load Balancer."
  value       = module.nlb.nlb_arn
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = module.ecs_cluster.cluster_arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = module.ecs_service.service_name
}

output "aurora_cluster_endpoint" {
  description = "Aurora PostgreSQL writer endpoint."
  value       = module.aurora_postgres.cluster_endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora PostgreSQL reader endpoint."
  value       = module.aurora_postgres.reader_endpoint
}

output "aurora_secret_arn" {
  description = "ARN of the Secrets Manager secret containing Aurora credentials."
  value       = module.secrets_manager.database_secret_arn
  sensitive   = true
}

output "s3_bucket_name" {
  description = "Encrypted S3 bucket used by the TRS application."
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the encrypted TRS S3 bucket."
  value       = module.s3.bucket_arn
}

output "route53_zone_id" {
  description = "Private Route53 hosted zone ID."
  value       = module.route53_zone.zone_id
}

output "route53_zone_name" {
  description = "Private Route53 hosted zone name."
  value       = module.route53_zone.zone_name
}

output "api_record_fqdn" {
  description = "Private API DNS record FQDN."
  value       = module.route53_api.record_fqdn
}

output "ecr_repository_url" {
  description = "ECR repository URL for the TRS image."
  value       = module.ecr.repository_url
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard name for TRS monitoring."
  value       = module.monitoring_dashboard.dashboard_name
}

output "cloudwatch_dashboard_arn" {
  description = "CloudWatch dashboard ARN for TRS monitoring."
  value       = module.monitoring_dashboard.dashboard_arn
}

output "kms_key_arns" {
  description = "KMS CMK ARNs created for S3, Aurora, Secrets Manager, and CloudWatch."
  value       = module.kms.key_arns
}

