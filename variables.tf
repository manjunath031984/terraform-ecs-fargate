variable "aws_account_id" {
  description = "AWS account ID allowed for deployments."
  type        = string
  default     = "980921723264"
}

variable "aws_region" {
  description = "AWS region for all regional resources."
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
  description = "Project name used for naming and tagging resources."
  type        = string
  default     = "trs"
}

variable "owner" {
  description = "Business or technical owner tag value."
  type        = string
  default     = "platform-engineering"
}

variable "cost_center" {
  description = "Cost center tag value."
  type        = string
  default     = "trs-platform"
}

variable "vpc_cidr" {
  description = "CIDR block for the production VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used for highly available resources."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets that host internet-facing load balancer components and NAT gateways."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_ecs_subnet_cidrs" {
  description = "CIDR blocks for private ECS application subnets."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for isolated Aurora database subnets."
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "private_hosted_zone_name" {
  description = "Private Route53 hosted zone name."
  type        = string
  default     = "trs.internal"
}

variable "api_record_name" {
  description = "Private DNS record name for the TRS API."
  type        = string
  default     = "api.trs.internal"
}

variable "certificate_domain_name" {
  description = "Domain name for the ACM certificate."
  type        = string
  default     = "api.trs.internal"
}

variable "ecs_task_cpu" {
  description = "CPU units for the TRS ECS task."
  type        = number
  default     = 1024
}

variable "ecs_task_memory" {
  description = "Memory in MiB for the TRS ECS task."
  type        = number
  default     = 2048
}

variable "ecs_desired_count" {
  description = "Desired number of TRS ECS tasks."
  type        = number
  default     = 2
}

variable "ecs_min_capacity" {
  description = "Minimum number of TRS ECS tasks."
  type        = number
  default     = 2
}

variable "ecs_max_capacity" {
  description = "Maximum number of TRS ECS tasks."
  type        = number
  default     = 10
}

variable "container_name" {
  description = "TRS application container name."
  type        = string
  default     = "trs"
}

variable "container_port" {
  description = "TRS application container port."
  type        = number
  default     = 8080
}

variable "container_image_tag" {
  description = "Container image tag deployed by ECS."
  type        = string
  default     = "latest"
}

variable "health_check_path" {
  description = "Application health check path for ALB and ECS target group health checks."
  type        = string
  default     = "/health"
}

variable "health_check_grace_period_seconds" {
  description = "Grace period before ECS service health checks are enforced."
  type        = number
  default     = 120
}

variable "aurora_engine_version" {
  description = "Aurora PostgreSQL engine version."
  type        = string
  default     = "15.4"
}

variable "aurora_database_name" {
  description = "Initial Aurora PostgreSQL database name."
  type        = string
  default     = "trs"
}

variable "aurora_master_username" {
  description = "Aurora PostgreSQL master username. Password is generated and stored in Secrets Manager."
  type        = string
  default     = "trs_admin"
}

variable "aurora_instance_class" {
  description = "Aurora PostgreSQL instance class."
  type        = string
  default     = "db.r6g.large"
}

variable "aurora_backup_retention_days" {
  description = "Aurora backup retention period in days."
  type        = number
  default     = 7
}

variable "aurora_deletion_protection" {
  description = "Enable deletion protection for Aurora."
  type        = bool
  default     = true
}

variable "s3_lifecycle_transition_days" {
  description = "Days before S3 objects transition to STANDARD_IA."
  type        = number
  default     = 30
}

variable "s3_lifecycle_expiration_days" {
  description = "Days before non-current S3 objects expire."
  type        = number
  default     = 365
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 30
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on load balancers where supported."
  type        = bool
  default     = true
}

variable "enable_alb_stickiness" {
  description = "Enable ALB target group cookie stickiness."
  type        = bool
  default     = true
}

variable "adfs_metadata_url" {
  description = "ADFS SAML metadata URL used by the TRS application through Atlas Email Proxy integration."
  type        = string
  default     = "https://adfs.example.com/FederationMetadata/2007-06/FederationMetadata.xml"
}

variable "atlas_email_proxy_url" {
  description = "Atlas Email Proxy endpoint used for authentication and email relay integration."
  type        = string
  default     = "https://atlas-email-proxy.example.com"
}

variable "writeapi_url" {
  description = "WriteAPI integration endpoint consumed by TRS."
  type        = string
  default     = "https://writeapi.example.com"
}

variable "data_lake_url" {
  description = "Data Lake integration endpoint consumed by TRS."
  type        = string
  default     = "https://datalake.example.com"
}

variable "cxo_url" {
  description = "CXO integration endpoint consumed by TRS."
  type        = string
  default     = "https://cxo.example.com"
}

variable "mds_url" {
  description = "MDS integration endpoint consumed by TRS."
  type        = string
  default     = "https://mds.example.com"
}

variable "pi_url" {
  description = "P&I integration endpoint consumed by TRS."
  type        = string
  default     = "https://pi.example.com"
}

variable "notification_email" {
  description = "Email address for alarm notifications."
  type        = string
  default     = "platform-alerts@example.com"
}

variable "allowed_internal_cidrs" {
  description = "Internal CIDR ranges allowed to reach the NLB."
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "additional_tags" {
  description = "Additional tags applied to all supported resources."
  type        = map(string)
  default     = {}
}

