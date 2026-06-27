aws_account_id = "980921723264"
aws_region     = "us-east-1"
environment    = "dev"
project_name   = "trs"
owner          = "platform-engineering"
cost_center    = "trs-platform"

vpc_cidr                 = "10.0.0.0/16"
availability_zones       = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs      = ["10.0.0.0/24", "10.0.1.0/24"]
private_ecs_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
database_subnet_cidrs    = ["10.0.20.0/24", "10.0.21.0/24"]

private_hosted_zone_name = "trs.internal"
api_record_name          = "api.trs.internal"
certificate_domain_name  = "api.trs.internal"

allowed_internal_cidrs = [
  "10.0.0.0/8",
  "172.16.0.0/12",
  "192.168.0.0/16"
]

ecs_task_cpu                      = 1024
ecs_task_memory                   = 2048
ecs_desired_count                 = 2
ecs_min_capacity                  = 2
ecs_max_capacity                  = 10
container_name                    = "trs"
container_port                    = 8080
container_image_tag               = "latest"
health_check_path                 = "/health"
health_check_grace_period_seconds = 120

aurora_engine_version        = "15.4"
aurora_database_name         = "trs"
aurora_master_username       = "trs_admin"
aurora_instance_class        = "db.r6g.large"
aurora_backup_retention_days = 7
aurora_deletion_protection   = true

s3_lifecycle_transition_days = 30
s3_lifecycle_expiration_days = 365
log_retention_days           = 30

enable_deletion_protection = true
enable_alb_stickiness      = true

adfs_metadata_url     = "https://adfs.example.com/FederationMetadata/2007-06/FederationMetadata.xml"
atlas_email_proxy_url = "https://atlas-email-proxy.example.com"
writeapi_url          = "https://writeapi.example.com"
data_lake_url         = "https://datalake.example.com"
cxo_url               = "https://cxo.example.com"
mds_url               = "https://mds.example.com"
pi_url                = "https://pi.example.com"
notification_email    = "platform-alerts@example.com"

additional_tags = {
  Application = "TRS"
  DataClass   = "Confidential"
  Terraform   = "true"
}
